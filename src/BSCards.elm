port module BSCards exposing (..)

import Browser
import File exposing (File)
import File.Select as Select
import Html exposing (Html, button, div, h5, header, li, p, span, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Parser
import Html.Parser.Util
import Http
import Parser exposing ((|.), (|=), Parser, chompUntil, chompWhile, getChompedString, keyword, run, succeed, symbol, token)
import Platform.Cmd as Cmd
import Task
import Zip exposing (Zip)
import Zip.Entry as Entry exposing (Entry)


type Status
    = New
    | Loaded String String
    | Error String


type alias Model =
    { roster : Roster
    , gameSystem : Maybe GameSystem
    , status : Status
    }


type Roster
    = Initial File
    | XML String
    | ZIP Zip
    | NoFile


type alias GameSystem =
    { name : String
    }



-- PORTS


port sendXml : ( String, String ) -> Cmd msg


port sendPrint : () -> Cmd msg


port receiveFragment : (String -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveFragment Recv


gameSystemAttribute : String
gameSystemAttribute =
    "gameSystemName"


isNameChar : Char -> Bool
isNameChar char =
    Char.isAlpha char || char == ' '


nameParser : Parser String
nameParser =
    getChompedString <|
        succeed ()
            |. chompWhile isNameChar


systemParser : Parser GameSystem
systemParser =
    succeed GameSystem
        |. chompUntil gameSystemAttribute
        |. keyword gameSystemAttribute
        |. symbol "="
        |. token "\""
        |= nameParser


parseGameSystem : String -> Maybe GameSystem
parseGameSystem content =
    content
        |> run systemParser
        |> Result.toMaybe


type Msg
    = OpenFileClicked
    | FileSelected File
    | FileRead String
    | GotXML String
    | GotFile
    | GotEntry (Maybe Entry)
    | GotZip (Maybe Zip)
    | GotStylesheet (Result Http.Error String)
    | SendXml String
    | Recv String
    | SendPrint


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenFileClicked ->
            ( model, Select.file [ ".ros", ".rosz" ] FileSelected )

        FileSelected file ->
            ( { model | roster = Initial file }, Task.perform FileRead (File.toString file) )

        FileRead content ->
            if String.startsWith """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>""" content == True then
                ( { model | roster = XML content }, Task.perform (always (GotXML content)) (Task.succeed ()) )

            else if String.startsWith """PK""" content then
                ( model, Task.perform (always GotFile) (Task.succeed ()) )

            else
                ( { model | status = Error "Not a Roster!" }, Cmd.none )

        GotXML content ->
            let
                gameSystem =
                    parseGameSystem content

                snakeName =
                    snakeCaseSystemName gameSystem
            in
            ( { model | roster = XML content, gameSystem = gameSystem }
            , Http.get
                { url = "/systems/" ++ snakeName ++ ".xsl"
                , expect = Http.expectString GotStylesheet
                }
            )

        GotFile ->
            case model.roster of
                Initial file ->
                    ( model
                    , file
                        |> File.toBytes
                        |> Task.map Zip.fromBytes
                        |> Task.perform GotZip
                    )

                XML content ->
                    ( model, Task.perform (always (GotXML content)) (Task.succeed ()) )

                ZIP _ ->
                    ( model, Cmd.none )

                NoFile ->
                    ( model, Cmd.none )

        GotZip maybeZip ->
            case maybeZip of
                Just zip ->
                    let
                        files =
                            zip
                                |> Zip.entries
                                |> List.head
                    in
                    ( { model | roster = ZIP zip }, Task.perform (always (GotEntry files)) (Task.succeed ()) )

                Nothing ->
                    ( model, Cmd.none )

        GotEntry entry ->
            case entry of
                Just data ->
                    case Entry.toString data of
                        Ok content ->
                            ( { model | roster = XML content }, Task.perform (always (GotXML content)) (Task.succeed ()) )

                        Err _ ->
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        GotStylesheet result ->
            case result of
                Ok xsl ->
                    if String.startsWith "<!DOCTYPE html>" xsl then
                        ( { model | status = Error "Game System not supported!" }, Cmd.none )

                    else
                        ( model, Task.perform (always (SendXml xsl)) (Task.succeed ()) )

                Err _ ->
                    ( { model | status = Error "Game System not supported!" }, Cmd.none )

        SendXml xsl ->
            case model.roster of
                XML xml ->
                    ( model, sendXml ( xml, xsl ) )

                ZIP _ ->
                    ( model, Cmd.none )

                Initial _ ->
                    ( model, Cmd.none )

                NoFile ->
                    ( model, Cmd.none )

        Recv data ->
            if String.startsWith "Failed" data == True then
                ( { model | status = Error data }, Cmd.none )

            else
                ( { model | status = Loaded (viewGameSystemName model.gameSystem) data, gameSystem = Nothing }, Cmd.none )

        SendPrint ->
            ( model, sendPrint () )


snakeCaseSystemName : Maybe GameSystem -> String
snakeCaseSystemName name =
    case name of
        Just game ->
            String.replace " " "_" (String.toLower game.name)

        Nothing ->
            ""


viewGameSystemName : Maybe GameSystem -> String
viewGameSystemName name =
    case name of
        Just game ->
            game.name

        Nothing ->
            ""


viewTextHtml : String -> List (Html.Html msg)
viewTextHtml text =
    case Html.Parser.run text of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []


type ConditionalClass
    = Hidden
    | Flex
    | None


viewUsageStep : String -> String -> String -> ConditionalClass -> Html msg
viewUsageStep number title description conditional =
    div
        [ class "flex grow bg-white p-6 shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)]"
        , classList [ ( "lg:hidden", conditional == Hidden ), ( "flex", conditional == Hidden ), ( "lg:flex", conditional == Flex ), ( "hidden", conditional == Flex ) ]
        ]
        [ div [ class "mr-4 flex w-12 items-center justify-center bg-gray-800 px-4 text-6xl text-white" ]
            [ span [] [ text number ] ]
        , div []
            [ h5 [ class "mb-2 text-4xl font-medium leading-tight text-neutral-800 lg:text-xl" ]
                [ text title ]
            , p [ class "mb-4 text-3xl text-neutral-600 lg:text-base" ]
                [ text description ]
            ]
        ]


viewIntro : Html msg
viewIntro =
    div
        [ id "start"
        , class "flex flex-col gap-4"
        ]
        [ div
            [ id "how"
            , class "flex flex-wrap gap-4"
            ]
            [ viewUsageStep "1" "Upload your Roster" "Choose File' button above and select your Roster file (.ros or .rosz)" None
            , viewUsageStep "2" "View your Cards" "The game system style sheets are formatted so you can easily view cards for the units on your mobile device." Hidden
            , viewUsageStep "2" "Print your Cards" "Click Print for a printer friendly version of the unit cards." Flex
            ]
        , div [ id "systems", class "bg-white p-12 shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)]" ]
            [ h5 [ class "mb-2 text-4xl font-medium leading-tight text-neutral-800 lg:text-xl" ]
                [ text "Supported Games" ]
            , ul [ class "list-inside list-disc text-3xl lg:text-base" ]
                [ li [] [ text "Stargrave" ]
                , li [] [ text "Xenos Rampant" ]
                ]
            ]
        ]


viewError : String -> Html Msg
viewError errorMessage =
    div
        [ id "error"
        , class "mb-6 bg-red-800 p-6 text-4xl text-white shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] lg:text-xl"
        ]
        [ text errorMessage ]


view : Model -> Html Msg
view model =
    div []
        [ header [ class "w-full bg-gray-800 p-6 lg:p-3 print:hidden" ]
            [ div [ class "mx-auto flex max-w-7xl items-center justify-between" ]
                [ div [ class "flex items-center flex-1" ]
                    [ div [ class "text-white" ] [ text "LOGO" ]
                    , div [ class "px-3" ]
                        [ button
                            [ onClick OpenFileClicked
                            , class "text-white text-xl uppercase bg-orange-600 p-2 font-semibold"
                            ]
                            [ text "Select Roster" ]
                        ]
                    ]
                , div [ class "flex-1 text-white text-xl text-center uppercase font-semibold" ]
                    [ span [] <|
                        case model.status of
                            Loaded gameSystem _ ->
                                [ text gameSystem ]

                            New ->
                                []

                            Error _ ->
                                []
                    ]
                , div [ class "hidden xl:flex xl:flex-1 cursor-pointer justify-end" ] <|
                    case model.status of
                        Loaded _ _ ->
                            [ button
                                [ onClick SendPrint
                                , class "bg-blue-800 px-4 py-2 text-3xl text-white"
                                ]
                                [ text "PRINT" ]
                            ]

                        New ->
                            []

                        Error _ ->
                            []
                ]
            ]
        , div [ class "mx-auto max-w-7xl p-4 xl:px-0" ] <|
            case model.status of
                Loaded _ fragment ->
                    [ div [ id "wrapper" ] (viewTextHtml fragment) ]

                New ->
                    [ viewIntro ]

                Error errorMessage ->
                    [ viewError errorMessage
                    , viewIntro
                    ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = always ( { roster = NoFile, gameSystem = Nothing, status = New }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
