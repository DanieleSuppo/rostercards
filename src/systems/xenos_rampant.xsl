<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bs="http://www.battlescribe.net/schema/rosterSchema"
>
    <xsl:output method="html"
    omit-xml-declaration="yes"
    media-type="text/html"
    encoding="utf-8"
    doctype-system="about:legacy-compat"
    indent="no"/>

    <xsl:template match="bs:roster/bs:forces/bs:force">
        <div class="grid grid-cols-1 lg:grid-cols-3 print:grid-cols-2 gap-4 print:gap-2 w-full">
            <xsl:apply-templates select="bs:selections/bs:selection[@type='unit']" />
            <xsl:apply-templates select=".//bs:rule" />
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
        <div class="flex flex-col border border-solid border-black text-4xl lg:text-2xl print:text-[0.7rem]/[1] print:w-[2.5in] print:min-h-[3.5in] print:break-inside-avoid">
            <div class="flex bg-gray-200 p-1 sm:p-3 print:sm:p-2 print:text-2xl justify-between">
                <div class="print:hidden"></div>
                <div class="text-center place-self-center uppercase">
                    <xsl:value-of select="@name" />
                </div>
                <div class="place-self-end text-right">
                    <xsl:value-of
            select="sum(.//bs:cost[@name=' Pts']/@value)"
          />
                    <span> PTS</span>
                </div>
            </div>
            <div class="flex justify-evenly py-2 print:py-1">
                <div class="w-20 h-20 print:w-8 print:h-8 bg-[url('img/heart.png')] bg-contain bg-no-repeat flex justify-center items-center text-5xl print:text-base">
                    <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Strength Points']/."
                    />
                </div>
                <div>
                </div>
                <div class="w-20 h-20 print:w-8 print:h-8 bg-[url('img/shield.png')] bg-contain bg-no-repeat flex justify-center items-center text-5xl print:text-base">
                    <xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Armour']/."
                    />
                </div>
            </div>
            <div class="grid grid-cols-3 print:text-[0.7rem]/[1.25]">
                <div class="bg-gray-200"></div>
                <div class="text-center bg-gray-200 font-semibold">ORDER</div>
                <div class="text-center bg-gray-200 font-semibold">VALUE</div>
                <div class="text-right">ATTACK</div>
                <div class="text-center"><xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Attack']/."
                    /></div>
                <div class="text-center"><xsl:variable
                      name="av"
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Attack Value']/."
                    />
                                        <xsl:value-of select="$av" />
                                        <xsl:if test="$av &lt; 6">
                                            <span>+</span>
                                        </xsl:if></div>
                <div class="text-right bg-gray-100">MOVE</div>
                <div class="text-center bg-gray-100"><xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Move']/."
                    /></div>
                <div class="text-center bg-gray-100"><xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Maximum Movement']/."
                    />
                                        <span>"</span></div>
                <div class="text-right">SHOOT</div>
                <div class="text-center"><xsl:value-of
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Shoot']/."
                    /></div>
                <div class="text-center"><xsl:variable
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
                                        <span>"</span></div>
                <div class="text-right bg-gray-100">DEFENCE</div>
                <div class="text-center bg-gray-100"><xsl:variable
                      name="dv"
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Defence Value']/."
                    />
                                        <xsl:value-of select="$dv" />
                                        <xsl:if test="$dv &lt; 6">
                                            <span>+</span>
                                        </xsl:if></div>
                <div class="text-center bg-gray-100">-</div>
                <div class="text-right border-b-2">COURAGE</div>
                <div class="text-center border-b-2">-</div>
                <div class="text-center border-b-2"><xsl:variable
                      name="courage"
                      select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='Courage']/."
                    />
                                        <xsl:value-of select="$courage" />
                                        <xsl:if test="$courage &lt; 6">
                                            <span>+</span>
                                        </xsl:if></div>
                <div class="text-right mt-1">SPECIAL</div>
                <div class="col-span-2 mt-1 pl-8 lg:pl-4 print:pl-2 text-2xl print:text-[0.7rem]/[1]">
                    <ul class="list-disc list-inside marker:mr-2">
                            <xsl:for-each select="bs:rules/bs:rule">
                                <li>
                                    <xsl:value-of select="@name" />
                                </li>
                            </xsl:for-each>
                        </ul>
                </div>
                <div class="text-right mt-1">OPTIONS</div>
                <div class="col-span-2 mt-1 pl-8 lg:pl-4 print:pl-2 text-2xl print:text-[0.7rem]/[1]">
                    <ul class="list-disc list-inside marker:mr-2">
                            <xsl:apply-templates
                select="bs:selections/bs:selection[@type='upgrade']"
              >
                                <xsl:with-param
                  name="category"
                >Options</xsl:with-param>
                            </xsl:apply-templates>
                        </ul>
                </div>
                <div class="text-right mt-1">XENOS RULES</div>
                <div class="col-span-2 mt-1 pl-8 lg:pl-4 print:pl-2 text-2xl print:text-[0.7rem]/[1]">
                    <ul class="list-disc list-inside marker:mr-2">
                            <xsl:apply-templates
                select="bs:selections/bs:selection[@type='upgrade']"
              >
                                <xsl:with-param
                  name="category"
                >Xenos Rules</xsl:with-param>
                            </xsl:apply-templates>
                        </ul>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="bs:rule">
        <div class="flex flex-col border border-solid border-black text-4xl lg:text-2xl print:text-[0.7rem]/[1] print:w-[2.5in] print:min-h-[3.5in] print:break-inside-avoid">
            <div class="bg-gray-200 p-1 sm:p-3 print:sm:p-2 print:text-3xl text-center uppercase">
                <xsl:value-of select="@name" />
            </div>
            <div class="p-5 print:p-3 print:text-base">
                <xsl:value-of select="bs:description/." />
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>