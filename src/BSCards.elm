module BSCards exposing (..)

import Browser
import File exposing (File)
import File.Select as Select
import Html exposing (Html, button, div, h5, header, li, p, span, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Parser exposing ((|.), (|=), Parser, chompUntil, chompWhile, getChompedString, keyword, run, succeed, symbol, token)
import Task


type alias Model =
    { error : String
    , fileContent : String
    , gameSystem : Maybe GameSystem
    }


type alias GameSystem =
    { name : String
    }


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
        |> Debug.log "result"
        |> Result.toMaybe


type Msg
    = OpenFileClicked
    | FileSelected File
    | FileRead String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenFileClicked ->
            ( model, Select.file [] FileSelected )

        FileSelected file ->
            ( model, Task.perform FileRead (File.toString file) )

        FileRead content ->
            ( { model | fileContent = content, gameSystem = parseGameSystem content }, Cmd.none )


snakeCaseSystemName : String -> String
snakeCaseSystemName name =
    String.replace " " "_" (String.toLower name)


viewGameSystemName : GameSystem -> String
viewGameSystemName game =
    snakeCaseSystemName game.name


view : Model -> Html Msg
view model =
    div []
        [ header [ class "w-full bg-gray-800 p-6 lg:p-3 print:hidden" ]
            [ div [ class "mx-auto flex max-w-7xl items-center justify-between" ]
                [ div [ class "flex items-center grow" ]
                    [ div [ class "text-white" ] [ text "LOGO" ]
                    , div [ class "px-3" ]
                        [ button
                            [ onClick OpenFileClicked
                            , class "text-white text-xl uppercase bg-orange-600 p-2 font-semibold"
                            ]
                            [ text "Select Roster" ]
                        ]
                    ]
                , div [ class "grow text-white text-2xl" ]
                    [ span []
                        [ text <|
                            case model.gameSystem of
                                Just game ->
                                    viewGameSystemName game

                                Nothing ->
                                    ""
                        ]
                    ]
                , div [ class "flex grow cursor-pointer justify-end" ]
                    [ div [ id "print", class "bg-blue-800 px-4 py-2 text-xl font-semibold text-white" ]
                        [ text "PRINT" ]
                    ]
                ]
            ]
        , div [ class "mx-auto max-w-7xl p-4 xl:px-0" ]
            [ if model.error /= "" then
                div
                    [ id "error"
                    , class "mb-6 bg-red-800 p-6 text-4xl text-white shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] lg:text-xl"
                    ]
                    [ text model.error ]

              else
                text ""
            , div
                [ id "start"
                , class "flex flex-col gap-4"
                ]
                [ div
                    [ id "how"
                    , class "flex flex-wrap gap-4"
                    ]
                    [ div [ id "how_upload", class "flex grow bg-white p-6 shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)]" ]
                        [ div [ class "mr-4 flex w-12 items-center justify-center bg-gray-800 px-4 text-6xl text-white" ]
                            [ span [] [ text "1" ] ]
                        , div []
                            [ h5 [ class "mb-2 text-4xl font-medium leading-tight text-neutral-800 lg:text-xl" ]
                                [ text "Upload your Roster" ]
                            , p [ class "mb-4 text-3xl text-neutral-600 lg:text-base" ]
                                [ text "Click the 'Choose File' button above and select your Roster file (.ros or .rosz)" ]
                            ]
                        ]
                    , div [ id "how_view", class "flex grow bg-white p-6 shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] lg:hidden" ]
                        [ div [ class "mr-4 flex w-12 items-center justify-center bg-gray-800 px-4 text-center text-6xl text-white" ]
                            [ span [] [ text "2" ] ]
                        , div []
                            [ h5 [ class "mb-2 text-4xl font-medium leading-tight text-neutral-800 lg:text-xl" ]
                                [ text "View your Cards" ]
                            , p [ class "mb-4 text-3xl text-neutral-600" ]
                                [ text "The game system style sheets are formatted, so you can easily view cards for the units on your mobile device." ]
                            ]
                        ]
                    , div [ id "how_print", class "hidden grow bg-white p-6 shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] lg:flex" ]
                        [ div [ class "mr-4 flex w-12 basis-4 items-center justify-center bg-gray-800 px-4 text-center text-6xl text-white" ]
                            [ span [] [ text "2" ] ]
                        , div []
                            [ h5 [ class "mb-2 text-4xl font-medium leading-tight text-neutral-800 lg:text-xl" ]
                                [ text "Print your Cards" ]
                            , p [ class "mb-4 text-base text-neutral-600" ]
                                [ text "Click Print for a printer friendly version of the unit cards." ]
                            ]
                        ]
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
            , div [ id "wrapper" ] []
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = always ( { error = "", fileContent = "", gameSystem = Nothing }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
