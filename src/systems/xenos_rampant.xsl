<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bs="http://www.battlescribe.net/schema/rosterSchema"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt"
>

    <xsl:template match="bs:roster/bs:forces/bs:force">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 w-full">
            <xsl:apply-templates
        select="bs:selections/bs:selection[@type='unit']"
      />
        </div>
    </xsl:template>

    <xsl:template match="bs:selection[@type='upgrade']">
        <xsl:param name="category" />
        <xsl:if test="bs:categories/bs:category/@name = $category">
            <li>
                <xsl:value-of select="@name" />
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template match="bs:selection[@type='unit']">
        <div
      class="flex flex-col border border-solid border-black p-2 print:break-inside-avoid"
    >
            <div class="flex bg-gray-200 mb-2 p-2"> <!-- header -->
                <div class="flex-1">
                    Name:
                </div>
                <div class="flex-1 text-center">
                    Type:
                    <xsl:value-of select="@name" />
                </div>
                <div class="flex-1 text-right">
                    Points:
                    <xsl:value-of
            select="sum(.//bs:cost[@name=' Pts']/@value)"
          />
                </div>
            </div>
            <div class="flex text-xs grow"> <!-- body -->
                <div class="flex flex-col flex-1 p-2 mr-1 bg-gray-200">
                    <div class="flex">
                        <div class="flex-1">
                            <table class="w-full">
                                <tr>
                                    <td>Attack</td>
                                    <td>
                                        <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Attack']/."
                    />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Move</td>
                                    <td>
                                        <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Move']/."
                    />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Shoot</td>
                                    <td>
                                        <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Shoot']/."
                    />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Courage</td>
                                    <td>
                                        <xsl:variable
                      name="courage"
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Courage']/."
                    />
                                        <xsl:value-of select="$courage" />
                                        <xsl:if test="$courage &lt; 6">
                                            <span>+</span>
                                        </xsl:if>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Armour</td>
                                    <td>
                                        <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Armour']/."
                    />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="flex-1">
                            <table class="w-full">
                                <tr>
                                    <td>Attack Value</td>
                                    <td>
                                        <xsl:variable
                      name="av"
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Attack Value']/."
                    />
                                        <xsl:value-of select="$av" />
                                        <xsl:if test="$av &lt; 6">
                                            <span>+</span>
                                        </xsl:if>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Defence Value</td>
                                    <td>
                                        <xsl:variable
                      name="dv"
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Defence Value']/."
                    />
                                        <xsl:value-of select="$dv" />
                                        <xsl:if test="$dv &lt; 6">
                                            <span>+</span>
                                        </xsl:if>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Shoot Value / Range</td>
                                    <td>
                                        <xsl:variable
                      name="sv"
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Shoot Value']/."
                    />
                                        <xsl:value-of select="$sv" />
                                        <xsl:if test="$sv &lt; 6">
                                            <span>+</span>
                                        </xsl:if>
                                        <span> / </span>
                                        <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Range']/."
                    />
                                        <span>"</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Max Move</td>
                                    <td>
                                        <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Maximum Movement']/."
                    />
                                        <span>"</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Strength Points</td>
                                    <td>
                                        <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Strength Points']/."
                    />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div> <!-- stats -->
                    <div class="px-3 my-2">
                        <span class="w-full block mb-2">Special Rules</span>
                        <ul class="list-disc list-inside pl-2">
                            <xsl:for-each select="bs:rules/bs:rule">
                                <li>
                                    <xsl:value-of select="@name" />
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div> <!-- spec rules -->
                </div>
                <div class="flex flex-col flex-1 p-2 ml-1 bg-gray-200">
                    <div>

                        <span class="w-full block mb-2">Options</span>
                        <ul class="list-disc list-inside pl-6">
                            <xsl:apply-templates
                select="bs:selections/bs:selection[@type='upgrade']"
              >
                                <xsl:with-param
                  name="category"
                >Options</xsl:with-param>
                            </xsl:apply-templates>
                        </ul>
                    </div> <!-- options -->
                    <div class="mt-2">
                        <span class="w-full block mb-2">Xenos Rules</span>
                        <ul class="list-disc list-inside pl-6">
                            <xsl:apply-templates
                select="bs:selections/bs:selection[@type='upgrade']"
              >
                                <xsl:with-param
                  name="category"
                >Xenos Rules</xsl:with-param>
                            </xsl:apply-templates>
                        </ul>
                    </div> <!-- xenos rules -->
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
