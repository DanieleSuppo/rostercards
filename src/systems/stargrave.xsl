<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bs="http://www.battlescribe.net/schema/rosterSchema"
>

  <xsl:template match="bs:roster/bs:forces/bs:force">
    <div class="grid grid-cols-1 xl:grid-cols-2 gap-4 print:grid-cols-3">
      <xsl:apply-templates select="bs:selections/bs:selection[@type='model']" />
    </div>
  </xsl:template>

  <xsl:template match="bs:profile[@typeName='Weapon']">
    <li>
      <div class="flex flex-row justify-between">
        <div class="basis-1/2">
          <xsl:value-of select="@name" />
        </div>
        <div class="basis-1/4 text-center">
          <xsl:value-of
            select="bs:characteristics/bs:characteristic[@name='Max Range']/."
          />
        </div>
        <div class="basis-1/4 text-center">
          <xsl:value-of
            select="bs:characteristics/bs:characteristic[@name='Damage Modifier']/."
          />
        </div>
      </div>
    </li>
  </xsl:template>

  <xsl:template match="bs:profile[@typeName='Equipment']">
    <li>
      <xsl:value-of select="@name" />
    </li>
  </xsl:template>

  <xsl:template match="bs:profile[@typeName='Power']">
    <li>
      <xsl:value-of select="@name" />
    </li>
  </xsl:template>

  <xsl:template match="bs:selection[@type='model']">
    <div class="bg-white border-solid border border-black text-4xl print:break-inside-avoid">
      <div class="flex items-center justify-between">
        <div class="px-2"></div>
        <xsl:choose>
          <xsl:when
            test="contains('Captain|First Mate', bs:categories/bs:category[@primary='true']/@name)"
          >
            <div
              class="py-1 px-2 rounded-bl-lg bg-red-600 text-white w-16 h-12 print:w-12 print:h-9 print:text-xl text-center"
            >
              <xsl:value-of
                select="bs:selections/bs:selection[@name='Level']/@number"
              />
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div
              class="py-1 px-2 rounded-bl-lg bg-sky-800 text-white w-16 h-12 text-center print:w-12 print:h-auto print:text-xl"
            >
              <xsl:value-of
                select="format-number(bs:costs/bs:cost[@name='Cr']/@value, '#')"
              />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
      <div class="flex print:text-base">
        <div class="basis-2/5 italic">
          <table class="table-auto font-semibold w-full">
            <tr class="even:bg-gray-200">
              <td class="text-right">MOVE</td>
              <td class="text-right pr-3">
                <xsl:value-of
                  select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='M']"
                />
              </td>
            </tr>
            <tr class="even:bg-gray-200">
              <td class="text-right">FIGHT</td>
              <td class="text-right pr-3">
                <xsl:value-of
                  select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='F']"
                />
              </td>
            </tr>
            <tr class="even:bg-gray-200">
              <td class="text-right">SHOOT</td>
              <td class="text-right pr-3">
                <xsl:value-of
                  select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='S']"
                />
              </td>
            </tr>
            <tr class="even:bg-gray-200">
              <td class="text-right">ARMOUR</td>
              <td class="text-right pr-3">
                <xsl:value-of
                  select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='A']"
                />
              </td>
            </tr>
            <tr class="even:bg-gray-200">
              <td class="text-right">WILL</td>
              <td class="text-right pr-3">
                <xsl:value-of
                  select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='W']"
                />
              </td>
            </tr>
            <tr class="even:bg-gray-200">
              <td class="text-right">HEALTH</td>
              <td class="text-right pr-3">
                <xsl:value-of
                  select="bs:profiles/bs:profile/bs:characteristics/bs:characteristic[@name='H']"
                />
              </td>
            </tr>
          </table>
        </div>
        <div class="basis-3/5 flex flex-row items-end justify-between">
          <div
            class="border border-solid border-black w-16 h-10 print:w-8 print:h-[1.6rem]"
          />
          <div class="font-semibold pr-2 uppercase text-right">
            <xsl:value-of select="@name" />
          </div>
        </div>
      </div>
      <div class="my-2">
        <div
          class="align-middle text-xl px-3 py-0.5 font-semibold bg-sky-800 text-white print:text-black print:bg-gray-200 print:text-sm"
        >
          WEAPONS
          &amp; EQUIPMENT
        </div>
        <div class="mx-6 my-2 print:mx-2 uppercase">
          <ul class="text-2xl print:text-base">
            <xsl:apply-templates
              select="bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Weapon']"
            />
            <xsl:apply-templates
              select="bs:selections/bs:selection/bs:profiles/bs:profile[@typeName='Equipment']"
            />
          </ul>
        </div>
      </div>

    </div>
  </xsl:template>

</xsl:stylesheet>
