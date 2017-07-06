######################################################################
# Script name: PFLootGenerator.ps1                                   #
# Version: 1.0                                                       #
# Created by: Jelle de Graaf                                         #
# Last change: 06-07-2017                                            #
# GitHub repository: https://github.com/JelleGraaf/PFLootGenerator   #
######################################################################
<#
.Synopsis
    Generate random Pathfinder RPG loot
.DESCRIPTION
    This script generates random pieces of loot, following the random tables in the Pathfinder RPG Core Rulebook
.EXAMPLE
    Full syntax: PFLootGenerator.ps1 -Number 1 -ItemPower minor -Type "armor or shield" -Manual
    This will give you one minor item of the type "armor or shield", while inputting every die roll manually
.EXAMPLE
    Short syntax: PFLootGenerator.ps1 10 major
    This will give you 10 major items
.EXAMPLE
    Short syntax: PFLootGenerator.ps1 5 medium scroll
    This will give you 5 medium scrolls
.EXAMPLE
    Shortest syntax: PFLootGenerator.ps1
    This will give you one minor item without further required input

.To fix:
    Multiple special abilities aren't joined with a comma and a space, which they should be
#>

Param(
    [Parameter(Position=1)]
    [ValidateRange(1,100)]
    [Int]
    $Number = 1 #To specify the number of times you want to generate, must be between 1 and 100
,
    [Parameter(Position=2)]
    [String]
    $ItemPower = "minor" #To specify the item power (minor, medium or major). Defaults to minor
,
    [Parameter(Position=3)]
    [String]
    $Type = $null #To specify the base item and skip the first roll
,
    [Switch]
    $Manual #To specify whether the script should rol the dice, or to do it yourself and input the results
)

#-------------------------
#region define functions
#-------------------------
Function Get-DNDRandomItemTypeMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..4 -contains $_}    {$ItemType = "armor or shield"}
        {5..9 -contains $_}    {$ItemType = "weapon"}
        {10..44 -contains $_}  {$ItemType = "potion"}
        {45..46 -contains $_}  {$ItemType = "ring"}
        {47..81 -contains $_}  {$ItemType = "scroll"}
        {82..91 -contains $_}  {$ItemType = "wand"}
        {92..100 -contains $_} {$ItemType = "wondrous item"}
    } #End Switch
    return $ItemType
} #End function Get-DNDRandomItemTypeMinor

Function Get-DNDRandomItemTypeMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..10 -contains $_}   {$ItemType = "armor or shield" }
        {11..20 -contains $_}  {$ItemType = "weapon"}
        {21..30 -contains $_}  {$ItemType = "potion"}
        {31..40 -contains $_}  {$ItemType = "ring"}
        {41..50 -contains $_}  {$ItemType = "rod"}
        {51..65 -contains $_}  {$ItemType = "scroll"}
        {66..68 -contains $_}  {$ItemType = "staff"}
        {69..83 -contains $_}  {$ItemType = "wand"}
        {84..100 -contains $_} {$ItemType = "wondrous item"}
    } #End Switch
    return $ItemType
} #End function Get-DNDRandomItemTypeMedium

Function Get-DNDRandomItemTypeMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..10 -contains $_}   {$ItemType = "armor or shield" }
        {11..20 -contains $_}  {$ItemType = "weapon"}
        {21..25 -contains $_}  {$ItemType = "potion"}
        {26..35 -contains $_}  {$ItemType = "ring"}
        {36..45 -contains $_}  {$ItemType = "rod"}
        {46..55 -contains $_}  {$ItemType = "scroll"}
        {56..75 -contains $_}  {$ItemType = "staff"}
        {76..80 -contains $_}  {$ItemType = "wand"}
        {81..100 -contains $_} {$ItemType = "wondrous item"}
    } #End Switch
    return $ItemType
} #End function Get-DNDRandomItemTypeMajor

Function Get-DNDRandomArmorMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..60 -contains $_}   {$ArmorType = "+1 shield"}
        {61..80 -contains $_}  {$ArmorType = "+1 armor"}
        {81..85 -contains $_}  {$ArmorType = "+2 shield"}
        {86..87 -contains $_}  {$ArmorType = "+2 armor"}
        {88..89 -contains $_}  {$ArmorType = "specific armor"}
        {90..91 -contains $_}  {$ArmorType = "specific shield"}
        {92..100 -contains $_} {$ArmorType = "special ability and roll again"}
    } #End Switch
    return $ArmorType
} #End function Get-DNDRandomArmorMinor

Function Get-DNDRandomArmorMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..5 -contains $_}    {$ArmorType = "+1 shield" }
        {6..10 -contains $_}   {$ArmorType = "+1 armor"}
        {11..20 -contains $_}  {$ArmorType = "+2 shield"}
        {21..30 -contains $_}  {$ArmorType = "+2 armor"}
        {31..40 -contains $_}  {$ArmorType = "+3 shield"}
        {41..50 -contains $_}  {$ArmorType = "+3 armor"}
        {51..55 -contains $_}  {$ArmorType = "+4 shield"}
        {56..57 -contains $_}  {$ArmorType = "+4 armor"}
        {58..60 -contains $_}  {$ArmorType = "specific armor"}
        {61..63 -contains $_}  {$ArmorType = "specific shield"}
        {64..100 -contains $_} {$ArmorType = "special ability and roll again"}
    } #End Switch
    return $ArmorType
} #End function Get-DNDRandomArmorMedium

Function Get-DNDRandomArmorMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..8 -contains $_}  {$ArmorType = "+3 shield"}
        {9..16 -contains $_}  {$ArmorType = "+3 armor"}
        {17..27 -contains $_}  {$ArmorType = "+4 shield"}
        {28..38 -contains $_}  {$ArmorType = "+4 armor"}
        {39..49 -contains $_}  {$ArmorType = "+5 shield"}
        {50..57 -contains $_}  {$ArmorType = "+5 armor"}
        {58..60 -contains $_}  {$ArmorType = "specific armor"}
        {61..63 -contains $_}  {$ArmorType = "specific shield"}
        {64..100 -contains $_}  {$ArmorType = "special ability and roll again"}
    } #End Switch
    return $ArmorType
} #End function Get-DNDRandomArmorMajor

Function Get-DNDRandomArmorType {
    $ArmorTypeList = @(
        "Padded"
        "Leather"
        "Studded leather"
        "Chain shirt"
        "Hide armor"
        "Scale mail"
        "Chainmail"
        "Breastplate"
        "Splint mail"
        "Banded mail"
        "Field Plate"
        "Half-plate"
        "Full plate"
        "Stoneplate"
    )
    
    $ArmorType = $ArmorTypeList | Get-Random
    return $ArmorType
} #End function Get-DNDRandomArmorType

Function Get-DNDRandomShieldType {
    $ShieldTypeList = @(
        "Buckler"
        "Light wooden shield"
        "Light steel shield"
        "Heavy wooden shield" 
        "Heavy steel shield"
        "Tower shield"
    )
    
    $ShieldType = $ShieldTypeList | Get-Random
    return $ShieldType
} #End function Get-DNDRandomShieldType

Function Get-DNDRandomArmorAbilityMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..25 -contains $_}   {$ArmorAbility = "glamered"}
        {26..32 -contains $_}  {$ArmorAbility = "fortification (light)"}
        {33..52 -contains $_}  {$ArmorAbility = "slick"}
        {53..92 -contains $_}  {$ArmorAbility = "shadow"}
        {93..96 -contains $_}  {$ArmorAbility = "spell resistance (13)"}
        {97 -contains $_}      {$ArmorAbility = "slick (improved)"}
        {98..99 -contains $_}  {$ArmorAbility = "shadow (improved)"}
        {100 -contains $_}     {$ArmorAbility = "roll twice again"}
    } #End Switch
    return $ArmorAbility
} #End function Get-DNDRandomArmorAbilityMinor

Function Get-DNDRandomArmorAbilityMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..5 -contains $_}    {$ArmorAbility = "glamered"}
        {6..8 -contains $_}    {$ArmorAbility = "fortification (light)"}
        {9..11 -contains $_}   {$ArmorAbility = "slick"}
        {12..17 -contains $_}  {$ArmorAbility = "shadow"}
        {18..19 -contains $_}  {$ArmorAbility = "spell resistance (13)"}
        {20..29 -contains $_}  {$ArmorAbility = "slick (improved)"}
        {30..49 -contains $_}  {$ArmorAbility = "shadow (improved)"}
        {50..74 -contains $_}  {$ArmorAbility = "energy resistance"}
        {75..79 -contains $_}  {$ArmorAbility = "ghost touch"}
        {80..84 -contains $_}  {$ArmorAbility = "invulnerability"}
        {85..89 -contains $_}  {$ArmorAbility = "fortification (moderate)"}
        {90..94 -contains $_}  {$ArmorAbility = "spell resistance (15)"}
        {95..99 -contains $_}  {$ArmorAbility = "wild"}
        {100 -contains $_}     {$ArmorAbility = "roll twice again"}
    } #End Switch
    return $ArmorAbility
} #End function Get-DNDRandomArmorAbilityMedium

Function Get-DNDRandomArmorAbilityMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..3 -contains $_}    {$ArmorAbility = "glamered"}
        {4 -contains $_}       {$ArmorAbility = "fortification (light)"}
        {5..7 -contains $_}    {$ArmorAbility = "slick (improved)"}
        {8..13 -contains $_}   {$ArmorAbility = "shadow (improved)"}
        {14..28 -contains $_}  {$ArmorAbility = "energy resistance"}
        {29..33 -contains $_}  {$ArmorAbility = "ghost touch"}
        {34..35 -contains $_}  {$ArmorAbility = "invulnerability"}
        {36..40 -contains $_}  {$ArmorAbility = "fortification, moderate"}
        {41..42 -contains $_}  {$ArmorAbility = "spell resistance (15)"}
        {43 -contains $_}      {$ArmorAbility = "wild"}
        {44..48 -contains $_}  {$ArmorAbility = "slick (greater)"}
        {49..58 -contains $_}  {$ArmorAbility = "shadow (greater)"}
        {59..83 -contains $_}  {$ArmorAbility = "energy resistance (improved)"}
        {84..88 -contains $_}  {$ArmorAbility = "spell resistance (17)"}
        {89 -contains $_}      {$ArmorAbility = "etherealness"}
        {90 -contains $_}      {$ArmorAbility = "undead controling"}
        {91..92 -contains $_}  {$ArmorAbility = "fortification (heavy)"}
        {93..94 -contains $_}  {$ArmorAbility = "spell resistance (19)"}
        {95..99 -contains $_}  {$ArmorAbility = "energy resistance (greater)"}
        {100 -contains $_}     {$ArmorAbility = "roll twice again"}
    } #End Switch
    return $ArmorAbility
} #End function Get-DNDRandomArmorAbilityMajor

Function Get-DNDSpecificArmorMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..50 -contains $_}    {$SpecificArmorMinor = "Mithral shirt"}
        {51..80 -contains $_}   {$SpecificArmorMinor = "Dragonhide plate"}
        {81..100 -contains $_}  {$SpecificArmorMinor = "Elven chain"}
    } #End Switch
    return $SpecificArmorMinor
} #End function Get-DNDSpecificArmorMinor

Function Get-DNDSpecificArmorMediumu{
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..25 -contains $_}   {$SpecificArmorMedium = "Mithral shirt"}
        {26..45 -contains $_}  {$SpecificArmorMedium = "Dragonhide plate"}
        {46..57 -contains $_}  {$SpecificArmorMedium = "Elven chain"}
        {58..67 -contains $_}  {$SpecificArmorMedium = "Rhino hide"}
        {68..82 -contains $_}  {$SpecificArmorMedium = "Adamantine breastplate"}
        {83..97 -contains $_}  {$SpecificArmorMedium = "Dwarven plate"}
        {98..100 -contains $_} {$SpecificArmorMedium = "Banded mail of luck"}
    } #End Switch
    return $SpecificArmorMedium
} #End function Get-DNDSpecificArmorMedium

Function Get-DNDSpecificArmorMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..10 -contains $_}   {$SpecificArmorMajor = "Adamantine breastplate"}
        {11..20 -contains $_}  {$SpecificArmorMajor = "Dwarven plate"}
        {21..32 -contains $_}  {$SpecificArmorMajor = "Banded mail of luck"}
        {33..50 -contains $_}  {$SpecificArmorMajor = "Celestial armor"}
        {51..60 -contains $_}  {$SpecificArmorMajor = "Plate armor of the deep"}
        {61..75 -contains $_}  {$SpecificArmorMajor = "Breastplate of command"}
        {76..90 -contains $_}  {$SpecificArmorMajor = "Mithral full plate of speed"}
        {91..100 -contains $_} {$SpecificArmorMajor = "Demon armor"}
    } #End Switch
    return $SpecificArmorMajor
} #End function Get-DNDSpecificArmorMajor

Function Get-DNDSpecificShieldMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..30 -contains $_}   {$SpecificShieldMinor = "Darkwood buckler"}
        {31..80 -contains $_}  {$SpecificShieldMinor = "Darkwood shield"}
        {81..95 -contains $_}  {$SpecificShieldMinor = "Mithral heavy shield"}
        {96..100 -contains $_} {$SpecificShieldMinor = "Caster's shield"}
    } #End Switch
    return $SpecificShieldMinor
} #End function Get-DNDSpecificShieldMinor

Function Get-DNDSpecificShieldMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..20 -contains $_}   {$SpecificShieldMinor = "Darkwood buckler"}
        {21..45 -contains $_}  {$SpecificShieldMinor = "Darkwood shield"}
        {46..70 -contains $_}  {$SpecificShieldMinor = "Mithral heavy shield"}
        {71..85 -contains $_}  {$SpecificShieldMinor = "Caster's shield"}
        {86..90 -contains $_}  {$SpecificShieldMinor = "Spined shield"}
        {91..95 -contains $_}  {$SpecificShieldMinor = "Lion's shield"}
        {96..100 -contains $_} {$SpecificShieldMinor = "Winged shield"}
    } #End Switch
    return $SpecificShieldMedium
} #End function Get-DNDSpecificShieldMedium

Function Get-DNDSpecificShieldMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..20 -contains $_}   {$SpecificShieldMinor = "Caster's shield"}
        {21..40 -contains $_}  {$SpecificShieldMinor = "Spined shield"}
        {41..60 -contains $_}  {$SpecificShieldMinor = "Lion's shield"}
        {61..90 -contains $_}  {$SpecificShieldMinor = "Winged shield"}
        {91..100 -contains $_} {$SpecificShieldMinor = "Absorbing shield"}
    } #End Switch
    return $SpecificShieldMajor
} #End function Get-DNDSpecificShieldMajor

Function Get-DNDRandomWeaponMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..70 -contains $_}   {$WeaponMinor = "+1"}
        {71..85 -contains $_}  {$WeaponMinor = "+2"}
        {86..90 -contains $_}  {$WeaponMinor = "Specific weapon"}
        {91..100 -contains $_} {$WeaponMinor = "Special ability and roll again"}
    } #End Switch
    return $WeaponMinor
} #End function Get-DNDRandomWeaponMinor

Function Get-DNDRandomWeaponMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..10 -contains $_}   {$WeaponMedium = "+1"}
        {11..29 -contains $_}  {$WeaponMedium = "+2"}
        {30..58 -contains $_}  {$WeaponMedium = "+3"}
        {59..62 -contains $_}  {$WeaponMedium = "+4"}
        {63..68 -contains $_}  {$WeaponMedium = "Specific weapon"}
        {69..100 -contains $_} {$WeaponMedium = "Special ability and roll again"}
    } #End Switch
    return $WeaponMedium
} #End function Get-DNDRandomWeaponMedium

Function Get-DNDRandomWeaponMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..20 -contains $_}  {$WeaponMajor = "+3"}
        {21..38 -contains $_}  {$WeaponMajor = "+4"}
        {39..49 -contains $_}  {$WeaponMajor = "+5"}
        {50..63 -contains $_}  {$WeaponMajor = "Specific weapon"}
        {64..100 -contains $_} {$WeaponMajor = "Special ability and roll again"}
    } #End Switch
    return $WeaponMajor
} #End function Get-DNDRandomWeaponMajor

Function Get-DNDMeleeWeaponType {
    $WeaponTypeList = @(
        "Axe, orc double"
        "Axe, throwing"
        "Battleaxe"
        "Chain, spiked"
        "Club"
        "Curve blade, elven"
        "Dagger"
        "Dagger, punching"
        "Falchion"
        "Flail"
        "Flail, dire"
        "Flail, heavy"
        "Gauntlet"
        "Gauntlet, spiked"
        "Glaive"
        "Greataxe"
        "Greatclub"
        "Greatsword"
        "Guisarme"
        "Halberd"
        "Hammer, gnome hooked"
        "Hammer, light"
        "Handaxe"
        "Kama"
        "Kukri"
        "Lance"
        "Longspear"
        "Longsword"
        "Mace, heavy"
        "Mace, light"
        "Morningstar"
        "Nunchaku"
        "Pick, heavy"
        "Pick, light"
        "Quarterstaff"
        "Ranseur"
        "Rapier"
        "Sai"
        "Sap"
        "Scimitar"
        "Scythe"
        "Shortspear"
        "Siangham"
        "Sickle"
        "Spear"
        "Starknife"
        "Sword, bastard"
        "Sword, short"
        "Sword, two-bladed"
        "Trident"
        "Unarmed strike"
        "Urgrosh, dwarven"
        "Waraxe, dwarven"
        "Warhammer"
        "Whip"
    ) #End ItemList
    
    $WeaponType = $WeaponTypeList | Get-Random
    return $WeaponType
} #End function Get-DNDMeleeWeaponType

Function Get-DNDRangedWeaponType {
    $WeaponTypeList = @(
        "Blowgun"
        "Bolas"
        "Crossbow, hand"
        "Crossbow, heavy"
        "Crossbow, light"
        "Crossbow, repeating heavy"
        "Crossbow, repeating light"
        "Dart"
        "Darts, blowgun"
        "Javelin"
        "Longbow"
        "Longbow, composite"
        "Net"
        "Shortbow"
        "Shortbow, composite"
        "Shuriken"
        "Sling"
        "Sling staff, halfling"
    ) #End ItemList
    
    $WeaponType = $WeaponTypeList | Get-Random
    return $WeaponType
} #End function Get-DNDWeaponType

Function Get-DNDSpecificWeaponMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..15 -contains $_}  {$SpecificWeaponMinor = "Sleep arrow"}
        {16..25 -contains $_}  {$SpecificWeaponMinor = "Screaming bolt"}
        {26..45 -contains $_}  {$SpecificWeaponMinor = "Silver dagger, masterwork"}
        {46..65 -contains $_}  {$SpecificWeaponMinor = "Cold iron longsword, masterwork"}
        {66..75 -contains $_}  {$SpecificWeaponMinor = "Javelin of lightning"}
        {76..80 -contains $_}  {$SpecificWeaponMinor = "Slaying arrow"}
        {81..90 -contains $_}  {$SpecificWeaponMinor = "Adamantine dagger"}
        {91..100 -contains $_} {$SpecificWeaponMinor = "Adamantine battleaxe"}
    } #End Switch
    return $SpecificWeaponMinor
} #End function Get-DNDSpecificWeaponMinor

Function Get-DNDSpecificWeaponMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..09 -contains $_}  {$SpecificWeaponMedium = "Javelin of lightning"}
        {10..15 -contains $_}  {$SpecificWeaponMedium = "Slaying arrow"}
        {16..24 -contains $_}  {$SpecificWeaponMedium = "Adamantine dagger"}
        {25..33 -contains $_}  {$SpecificWeaponMedium = "Adamantine battleaxe"}
        {34..37 -contains $_}  {$SpecificWeaponMedium = "Slaying arrow (greater)"}
        {38..40 -contains $_}  {$SpecificWeaponMedium = "Shatterspike"}
        {41..46 -contains $_}  {$SpecificWeaponMedium = "Dagger of venom"}
        {47..51 -contains $_}  {$SpecificWeaponMedium = "Trident of warning"}
        {52..57 -contains $_}  {$SpecificWeaponMedium = "Assassin's dagger"}
        {58..62 -contains $_}  {$SpecificWeaponMedium = "Shifter's sorrow"}
        {63..66 -contains $_}  {$SpecificWeaponMedium = "Trident of fish command"}
        {67..74 -contains $_}  {$SpecificWeaponMedium = "Flame tongue"}
        {75..79 -contains $_}  {$SpecificWeaponMedium = "Luck blade (0 wishes)"}
        {80..86 -contains $_}  {$SpecificWeaponMedium = "Sword of subtlety"}
        {87..91 -contains $_}  {$SpecificWeaponMedium = "Sword of the planes"}
        {92..95 -contains $_}  {$SpecificWeaponMedium = "Nine lives stealer"}
        {96..98 -contains $_}  {$SpecificWeaponMedium = "Oathbow"}
        {99..100 -contains $_} {$SpecificWeaponMedium = "Sword of life stealing"}
    } #End Switch
    return $SpecificWeaponMedium
} #End function Get-DNDSpecificWeaponMedium

Function Get-DNDSpecificWeaponMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..04 -contains $_} {$SpecificWeaponMajor = "Assassin's dagger"}
        {05..07 -contains $_} {$SpecificWeaponMajor = "Shifter's sorrow"}
        {08..09 -contains $_} {$SpecificWeaponMajor = "Trident of fish command"}
        {10..13 -contains $_} {$SpecificWeaponMajor = "Flame tongue"}
        {14..17 -contains $_} {$SpecificWeaponMajor = "Luck blade (0 wishes)"}
        {18..24 -contains $_} {$SpecificWeaponMajor = "Sword of subtlety"}
        {25..31 -contains $_} {$SpecificWeaponMajor = "Sword of the planes"}
        {32..37 -contains $_} {$SpecificWeaponMajor = "Nine lives stealer"}
        {38..42 -contains $_} {$SpecificWeaponMajor = "Oathbow"}
        {43..46 -contains $_} {$SpecificWeaponMajor = "Sword of life stealing"}
        {47..51 -contains $_} {$SpecificWeaponMajor = "Mace of terror"}
        {52..57 -contains $_} {$SpecificWeaponMajor = "Life-drinker"}
        {58..62 -contains $_} {$SpecificWeaponMajor = "Sylvan scimitar"}
        {63..67 -contains $_} {$SpecificWeaponMajor = "Rapier of puncturing"}
        {68..73 -contains $_} {$SpecificWeaponMajor = "Sun blade"}
        {74..79 -contains $_} {$SpecificWeaponMajor = "Frost brand"}
        {80..84 -contains $_} {$SpecificWeaponMajor = "Dwarven thrower"}
        {85..91 -contains $_} {$SpecificWeaponMajor = "Luck blade (1 wish)"}
        {92..95 -contains $_} {$SpecificWeaponMajor = "Mace of smiting"}
        {96..97 -contains $_} {$SpecificWeaponMajor = "Luck blade (2 wishes)"}
        {98..99 -contains $_} {$SpecificWeaponMajor = "Holy avenger"}
        {100 -contains $_}    {$SpecificWeaponMajor = "Luck blade (3 wishes)"}
    } #End Switch
    return $SpecificWeaponMajor
} #End function Get-DNDSpecificWeaponMajor

Function Get-DNDRandomMeleeWeaponAbilityMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..10 -contains $_}  {$WeaponAbility = "Bane"}
        {11..17 -contains $_}  {$WeaponAbility = "Defending"}
        {18..27 -contains $_}  {$WeaponAbility = "Flaming"}
        {28..37 -contains $_}  {$WeaponAbility = "Frost"}
        {38..47 -contains $_}  {$WeaponAbility = "Shock"}
        {48..56 -contains $_}  {$WeaponAbility = "Ghost touch"}
        {57..67 -contains $_}  {$WeaponAbility = "Keen"}
        {68..71 -contains $_}  {$WeaponAbility = "Ki Focus"}
        {72..75 -contains $_}  {$WeaponAbility = "Merciful"}
        {76..82 -contains $_}  {$WeaponAbility = "Mighty cleaving"}
        {83..87 -contains $_}  {$WeaponAbility = "Spell storing"}
        {88..91 -contains $_}  {$WeaponAbility = "Throwing"}
        {92..95 -contains $_}  {$WeaponAbility = "Thundering"}
        {96..99 -contains $_}  {$WeaponAbility = "Vicious"}
        {100    -contains $_}  {$WeaponAbility = "Roll again twice"}
    } #End Switch
    return $WeaponAbility
} #End function Get-DNDRandomMeleeWeaponAbilityMinor

Function Get-DNDRandomMeleeWeaponAbilityMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..06 -contains $_}  {$WeaponAbility = "Bane"}
        {07..12 -contains $_}  {$WeaponAbility = "Defending"}
        {13..19 -contains $_}  {$WeaponAbility = "Flaming"}
        {20..26 -contains $_}  {$WeaponAbility = "Frost"}
        {27..33 -contains $_}  {$WeaponAbility = "Shock"}
        {34..38 -contains $_}  {$WeaponAbility = "Ghost touch"}
        {39..44 -contains $_}  {$WeaponAbility = "Keen"}
        {45..48 -contains $_}  {$WeaponAbility = "Ki Focus"}
        {49..50 -contains $_}  {$WeaponAbility = "Merciful"}
        {51..54 -contains $_}  {$WeaponAbility = "Mighty cleaving"}
        {55..59 -contains $_}  {$WeaponAbility = "Spell storing"}
        {60..63 -contains $_}  {$WeaponAbility = "Throwing"}
        {64..65 -contains $_}  {$WeaponAbility = "Thundering"}
        {66..69 -contains $_}  {$WeaponAbility = "Vicious"}
        {70..72 -contains $_}  {$WeaponAbility = "Anarchic"}
        {73..75 -contains $_}  {$WeaponAbility = "Axiomatic"}
        {76..78 -contains $_}  {$WeaponAbility = "Disruption"}
        {79..81 -contains $_}  {$WeaponAbility = "Flaming burst"}
        {82..84 -contains $_}  {$WeaponAbility = "Icy burst"}
        {85..87 -contains $_}  {$WeaponAbility = "Holy"}
        {88..90 -contains $_}  {$WeaponAbility = "Shocking burst"}
        {91..93 -contains $_}  {$WeaponAbility = "Unholy"}
        {94..95 -contains $_}  {$WeaponAbility = "Wounding"}
        {96..100 -contains $_} {$WeaponAbility = "Roll again twice"}
    } #End Switch
    return $WeaponAbility
} #End function Get-DNDRandomMeleeWeaponAbilityMedium

Function Get-DNDRandomMeleeWeaponAbilityMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..03 -contains $_}  {$WeaponAbility = "Bane"}
        {04..06 -contains $_}  {$WeaponAbility = "Flaming"}
        {07..09 -contains $_}  {$WeaponAbility = "Frost"}
        {10..12 -contains $_}  {$WeaponAbility = "Shock"}
        {13..15 -contains $_}  {$WeaponAbility = "Ghost touch"}
        {16..19 -contains $_}  {$WeaponAbility = "Ki Focus"}
        {20..21 -contains $_}  {$WeaponAbility = "Mighty cleaving"}
        {22..24 -contains $_}  {$WeaponAbility = "Spell storing"}
        {25..28 -contains $_}  {$WeaponAbility = "Throwing"}
        {29..32 -contains $_}  {$WeaponAbility = "Thundering"}
        {33..36 -contains $_}  {$WeaponAbility = "Vicious"}
        {37..41 -contains $_}  {$WeaponAbility = "Anarchic"}
        {42..46 -contains $_}  {$WeaponAbility = "Axiomatic"}
        {47..49 -contains $_}  {$WeaponAbility = "Disruption"}
        {50..54 -contains $_}  {$WeaponAbility = "Flaming burst"}
        {55..59 -contains $_}  {$WeaponAbility = "Icy burst"}
        {60..64 -contains $_}  {$WeaponAbility = "Holy"}
        {65..69 -contains $_}  {$WeaponAbility = "Shocking burst"}
        {70..74 -contains $_}  {$WeaponAbility = "Unholy"}
        {75..78 -contains $_}  {$WeaponAbility = "Wounding"}
        {79..83 -contains $_}  {$WeaponAbility = "Speed"}
        {84..86 -contains $_}  {$WeaponAbility = "Brilliant energy"}
        {87..88 -contains $_}  {$WeaponAbility = "Dancing"}
        {89..90 -contains $_}  {$WeaponAbility = "Vorpal"}
        {91..100 -contains $_} {$WeaponAbility = "Roll again twice"}
    } #End Switch
    return $WeaponAbility
} #End function Get-DNDRandomMeleeWeaponAbilityMajor



Function Get-DNDRandomRangedWeaponAbilityMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..12 -contains $_}  {$WeaponAbility = "Bane"}
        {13..25 -contains $_}  {$WeaponAbility = "Distance"}
        {26..40 -contains $_}  {$WeaponAbility = "Flaming"}
        {41..55 -contains $_}  {$WeaponAbility = "Frost"}
        {56..60 -contains $_}  {$WeaponAbility = "Merciful"}
        {61..68 -contains $_}  {$WeaponAbility = "Returning"}
        {69..83 -contains $_}  {$WeaponAbility = "Shock"}
        {84..93 -contains $_}  {$WeaponAbility = "Seeking"}
        {94..99 -contains $_}  {$WeaponAbility = "Thundering"}
        {100    -contains $_}  {$WeaponAbility = "Roll again twice"}
    } #End Switch
    return $WeaponAbility
} #End function Get-DNDRandomRangedWeaponAbilityMinor

Function Get-DNDRandomRangedWeaponAbilityMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..08 -contains $_}  {$WeaponAbility = "Bane"}
        {09..16 -contains $_}  {$WeaponAbility = "Distance"}
        {17..28 -contains $_}  {$WeaponAbility = "Flaming"}
        {29..40 -contains $_}  {$WeaponAbility = "Frost"}
        {41..42 -contains $_}  {$WeaponAbility = "Merciful"}
        {43..47 -contains $_}  {$WeaponAbility = "Returning"}
        {48..59 -contains $_}  {$WeaponAbility = "Shock"}
        {60..64 -contains $_}  {$WeaponAbility = "Seeking"}
        {65..68 -contains $_}  {$WeaponAbility = "Thundering"}
        {69..71 -contains $_}  {$WeaponAbility = "Anarchic"}
        {72..74 -contains $_}  {$WeaponAbility = "Axiomatic"}
        {75..79 -contains $_}  {$WeaponAbility = "Flaming burst"}
        {80..82 -contains $_}  {$WeaponAbility = "Holy"}
        {83..87 -contains $_}  {$WeaponAbility = "Icy burst"}
        {88..92 -contains $_}  {$WeaponAbility = "Shocking burst"}
        {93..95 -contains $_}  {$WeaponAbility = "Unholy"}
        {96..100 -contains $_} {$WeaponAbility = "Roll again twice"}
    } #End Switch
    return $WeaponAbility
} #End function Get-DNDRandomRangedWeaponAbilityMedium

Function Get-DNDRandomRangedWeaponAbilityMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..04 -contains $_}  {$WeaponAbility = "Bane"}
        {05..08 -contains $_}  {$WeaponAbility = "Distance"}
        {09..12 -contains $_}  {$WeaponAbility = "Flaming"}
        {13..16 -contains $_}  {$WeaponAbility = "Frost"}
        {17..21 -contains $_}  {$WeaponAbility = "Returning"}
        {22..25 -contains $_}  {$WeaponAbility = "Shock"}
        {26..27 -contains $_}  {$WeaponAbility = "Seeking"}
        {28..29 -contains $_}  {$WeaponAbility = "Thundering"}
        {30..34 -contains $_}  {$WeaponAbility = "Anarchic"}
        {35..39 -contains $_}  {$WeaponAbility = "Axiomatic"}
        {40..49 -contains $_}  {$WeaponAbility = "Flaming burst"}
        {50..54 -contains $_}  {$WeaponAbility = "Holy"}
        {55..64 -contains $_}  {$WeaponAbility = "Icy burst"}
        {65..74 -contains $_}  {$WeaponAbility = "Shocking burst"}
        {75..79 -contains $_}  {$WeaponAbility = "Unholy"}
        {80..84 -contains $_}  {$WeaponAbility = "Speed"}
        {85..90 -contains $_}  {$WeaponAbility = "Brilliant energy"}
        {91..100 -contains $_} {$WeaponAbility = "Roll again twice"}
    } #End Switch
    return $WeaponAbility
} #End function Get-DNDRandomRangedWeaponAbilityMajor

Function Get-DNDPotionMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..20 -contains $_}  {$PotionMinor = "zero"}
        {21..60 -contains $_}  {$PotionMinor = "first"}
        {61..100 -contains $_} {$PotionMinor = "second"}
    } #End Switch
    return $PotionMinor
} #End function Get-DNDPotionMinor

Function Get-DNDPotionMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..20 -contains $_}  {$PotionMedium = "first"}
        {21..60 -contains $_}  {$PotionMedium = "second"}
        {61..100 -contains $_} {$PotionMedium = "third"}
    } #End Switch
    return $PotionMedium
} #End function Get-DNDPotionMedium

Function Get-DNDPotionMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..20 -contains $_}  {$PotionMajor = "second"}
        {21..100 -contains $_} {$PotionMajor = "third"}
    } #End Switch
    return $PotionMajor
} #End function Get-DNDPotionMajor

Function Get-DNDRingMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..18 -contains $_}  {$RingMinor = "Protection +1"}
        {19..28 -contains $_}  {$RingMinor = "Feather falling"}
        {29..36 -contains $_}  {$RingMinor = "Sustenance"}
        {37..44 -contains $_}  {$RingMinor = "Climbing"}
        {45..52 -contains $_}  {$RingMinor = "Jumping"}
        {53..60 -contains $_}  {$RingMinor = "Swimming"}
        {61..70 -contains $_}  {$RingMinor = "Counterspells"}
        {71..75 -contains $_}  {$RingMinor = "Mind shielding"}
        {76..80 -contains $_}  {$RingMinor = "Protection +2"}
        {81..85 -contains $_}  {$RingMinor = "Force shield"}
        {86..90 -contains $_}  {$RingMinor = "Ram, the"}
        {91..93 -contains $_}  {$RingMinor = "Animal friendship"}
        {94..96 -contains $_}  {$RingMinor = "Energy resistance, minor"}
        {97..98 -contains $_}  {$RingMinor = "Chameleon power"}
        {99..100 -contains $_} {$RingMinor = "Water walking"}
    } #End Switch
    return $RingMinor
} #End function Get-DNDRingMinor

Function Get-DNDRingMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..05 -contains $_}  {$RingMedium = "Counterspells"}
        {06..08 -contains $_}  {$RingMedium = "Mind shielding"}
        {09..18 -contains $_}  {$RingMedium = "Protection +2"}
        {19..23 -contains $_}  {$RingMedium = "Force shield"}
        {24..28 -contains $_}  {$RingMedium = "Ram, the"}
        {29..34 -contains $_}  {$RingMedium = "Climbing, improved"}
        {35..40 -contains $_}  {$RingMedium = "Jumping, improved"}
        {41..46 -contains $_}  {$RingMedium = "Swimming, improved"}
        {47..50 -contains $_}  {$RingMedium = "Animal friendship"}
        {51..56 -contains $_}  {$RingMedium = "Energy resistance, minor"}
        {57..61 -contains $_}  {$RingMedium = "Chameleon power"}
        {62..66 -contains $_}  {$RingMedium = "Water walking"}
        {67..71 -contains $_}  {$RingMedium = "Protection +3"}
        {72..76 -contains $_}  {$RingMedium = "Spell storing, minor"}
        {77..81 -contains $_}  {$RingMedium = "Invisibility"}
        {82..85 -contains $_}  {$RingMedium = "Wizardry (I)"}
        {86..90 -contains $_}  {$RingMedium = "Evasion"}
        {91..93 -contains $_}  {$RingMedium = "X-ray vision"}
        {94..97 -contains $_}  {$RingMedium = "Blinking"}
        {98..100 -contains $_} {$RingMedium = "Energy resistance, major"}
    } #End Switch
    return $RingMedium
} #End function Get-DNDRingMedium

Function Get-DNDRingMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..02 -contains $_} {$RingMajor = "Energy resistance, minor"}
        {03..07 -contains $_} {$RingMajor = "Protection +3"}
        {08..10 -contains $_} {$RingMajor = "Spell storing, minor"}
        {11..15 -contains $_} {$RingMajor = "Invisibility"}
        {16..19 -contains $_} {$RingMajor = "Wizardry (I)"}
        {20..25 -contains $_} {$RingMajor = "Evasion"}
        {26..28 -contains $_} {$RingMajor = "X-ray vision"}
        {29..32 -contains $_} {$RingMajor = "Blinking"}
        {33..39 -contains $_} {$RingMajor = "Energy resistance, major"}
        {40..49 -contains $_} {$RingMajor = "Protection +4"}
        {50..55 -contains $_} {$RingMajor = "Wizardry (II)"}
        {56..60 -contains $_} {$RingMajor = "Freedom of movement"}
        {61..63 -contains $_} {$RingMajor = "Energy resistance, greater"}
        {64..65 -contains $_} {$RingMajor = "Friend shield (pair)"}
        {66..70 -contains $_} {$RingMajor = "Protection +5"}
        {71..74 -contains $_} {$RingMajor = "Shooting stars"}
        {75..79 -contains $_} {$RingMajor = "Spell storing"}
        {80..83 -contains $_} {$RingMajor = "Wizardry (III)"}
        {84..86 -contains $_} {$RingMajor = "Telekinesis"}
        {87..88 -contains $_} {$RingMajor = "Regeneration"}
        {89..91 -contains $_} {$RingMajor = "Spell turning"}
        {92..93 -contains $_} {$RingMajor = "Wizardry (IV)"}
        {94 -contains $_}     {$RingMajor = "Three wishes"}
        {95 -contains $_}     {$RingMajor = "Djinni calling"}
        {96 -contains $_}     {$RingMajor = "Elemental command (air)"}
        {97 -contains $_}     {$RingMajor = "Elemental command (earth)"}
        {98 -contains $_}     {$RingMajor = "Elemental command (fire)"}
        {99 -contains $_}     {$RingMajor = "Elemental command (water)"}
        {100 -contains $_}    {$RingMajor = "Spell storing, major"}
    } #End Switch
    return $RingMajor
} #End function Get-DNDRingMajor

Function Get-DNDRodMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..07 -contains $_}  {$RodMedium = "Metamagic, Enlarge, lesser"}
        {08..14 -contains $_}  {$RodMedium = "Metamagic, Extend, lesser"}
        {15..21 -contains $_}  {$RodMedium = "Metamagic, Silent, lesser"}
        {22..28 -contains $_}  {$RodMedium = "Immovable"}
        {29..35 -contains $_}  {$RodMedium = "Metamagic, Empower, lesser"}
        {36..42 -contains $_}  {$RodMedium = "Metal and mineral detection"}
        {43..53 -contains $_}  {$RodMedium = "Cancellation"}
        {54..57 -contains $_}  {$RodMedium = "Metamagic, Enlarge"}
        {58..61 -contains $_}  {$RodMedium = "Metamagic, Extend"}
        {62..65 -contains $_}  {$RodMedium = "Metamagic, Silent"}
        {66..71 -contains $_}  {$RodMedium = "Wonder"}
        {72..79 -contains $_}  {$RodMedium = "the Python"}
        {80..83 -contains $_}  {$RodMedium = "Metamagic, Maximize, lesser"}
        {84..89 -contains $_}  {$RodMedium = "Flame extinguishing"}
        {90..97 -contains $_}  {$RodMedium = "the Viper"}
        {98..99 -contains $_}  {$RodMedium = "Metamagic, Empower"}
        {100    -contains $_}  {$RodMedium = "Metamagic, Quicken, lesser"}
    } #End Switch
    return $RodMedium
} #End function Get-DNDRodMedium

Function Get-DNDRodMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..04 -contains $_} {$RodMajor = "Cancellation"}
        {05..06 -contains $_} {$RodMajor = "Metamagic, Enlarge"}
        {07..08 -contains $_} {$RodMajor = "Metamagic, Extend"}
        {09..10 -contains $_} {$RodMajor = "Metamagic, Silent"}
        {11..14 -contains $_} {$RodMajor = "Wonder"}
        {15..19 -contains $_} {$RodMajor = "the Python"}
        {20..21 -contains $_} {$RodMajor = "Flame extinguishing"}
        {22..25 -contains $_} {$RodMajor = "the Viper"}
        {26..30 -contains $_} {$RodMajor = "Enemy detection"}
        {31..36 -contains $_} {$RodMajor = "Metamagic, Enlarge, greater"}
        {37..42 -contains $_} {$RodMajor = "Metamagic, Extend, greater"}
        {43..48 -contains $_} {$RodMajor = "Metamagic, Silent, greater"}
        {49..53 -contains $_} {$RodMajor = "Splendor"}
        {54..58 -contains $_} {$RodMajor = "Withering"}
        {59..64 -contains $_} {$RodMajor = "Metamagic, Empower"}
        {65..69 -contains $_} {$RodMajor = "Thunder and lightning"}
        {70..73 -contains $_} {$RodMajor = "Metamagic, Quicken, lesser"}
        {74..77 -contains $_} {$RodMajor = "Negation"}
        {78..80 -contains $_} {$RodMajor = "Absorption"}
        {81..84 -contains $_} {$RodMajor = "Flailing"}
        {85..86 -contains $_} {$RodMajor = "Metamagic, Maximize"}
        {87..88 -contains $_} {$RodMajor = "Rulership"}
        {89..90 -contains $_} {$RodMajor = "Security"}
        {91..92 -contains $_} {$RodMajor = "Lordly might"}
        {93..94 -contains $_} {$RodMajor = "Metamagic, Empower, greater"}
        {95..96 -contains $_} {$RodMajor = "Metamagic, Quicken"}
        {97..98 -contains $_} {$RodMajor = "Alertness"}
        {99     -contains $_} {$RodMajor = "Metamagic, Maximize, greater"}
        {100    -contains $_} {$RodMajor = "Metamagic, Quicken, greater"}
    } #End Switch
    return $RodMajor
} #End function Get-DNDRodMajor

Function Get-DNDScrollMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..05 -contains $_}  {$ScrollMinor = "zero"}
        {06..50 -contains $_}  {$ScrollMinor = "first"}
        {51..95 -contains $_}  {$ScrollMinor = "second"}
        {96..100 -contains $_} {$ScrollMinor = "third"}
    } #End Switch
    return $ScrollMinor
} #End function Get-DNDScrollMinor

Function Get-DNDScrollMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..05 -contains $_}  {$ScrollMedium = "second"}
        {06..65 -contains $_}  {$ScrollMedium = "third"}
        {66..95 -contains $_}  {$ScrollMedium = "fourth"}
        {96..100 -contains $_} {$ScrollMedium = "fifth"}
    } #End Switch
    return $ScrollMedium
} #End function Get-DNDScrollMedium

Function Get-DNDScrollMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..05 -contains $_}  {$ScrollMajor = "fourth"}
        {06..50 -contains $_}  {$ScrollMajor = "fifth"}
        {51..70 -contains $_}  {$ScrollMajor = "sixth"}
        {71..85 -contains $_}  {$ScrollMajor = "seventh"}
        {86..95 -contains $_}  {$ScrollMajor = "eighth"}
        {96..100 -contains $_} {$ScrollMajor = "ninth"}
    } #End Switch
    return $ScrollMajor
} #End function Get-DNDScrollMajor

Function Get-DNDStaffMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..15 -contains $_}  {$StaffMedium = "Charming"}
        {16..30 -contains $_}  {$StaffMedium = "Fire"}
        {31..40 -contains $_}  {$StaffMedium = "Swarming insects"}
        {41..55 -contains $_}  {$StaffMedium = "Size alteration"}
        {56..75 -contains $_}  {$StaffMedium = "Healing"}
        {76..90 -contains $_}  {$StaffMedium = "Frost"}
        {91..95 -contains $_}  {$StaffMedium = "Illumination"}
        {96..100 -contains $_} {$StaffMedium = "Defense"}
    } #End Switch
    return $StaffMedium
} #End function Get-DNDStaffMedium

Function Get-DNDStaffMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..03 -contains $_}  {$StaffMajor = "Charming"}
        {04..09 -contains $_}  {$StaffMajor = "Fire"}
        {10..11 -contains $_}  {$StaffMajor = "Swarming insects"}
        {12..13 -contains $_}  {$StaffMajor = "Size alteration"}
        {14..19 -contains $_}  {$StaffMajor = "Healing"}
        {20..24 -contains $_}  {$StaffMajor = "Frost"}
        {25..31 -contains $_}  {$StaffMajor = "Illumination"}
        {32..38 -contains $_}  {$StaffMajor = "Defense"}
        {39..45 -contains $_}  {$StaffMajor = "Abjuration"}
        {46..50 -contains $_}  {$StaffMajor = "Conjuration"}
        {51..55 -contains $_}  {$StaffMajor = "Divination"}
        {56..60 -contains $_}  {$StaffMajor = "Enchantment"}
        {61..65 -contains $_}  {$StaffMajor = "Evocation"}
        {66..70 -contains $_}  {$StaffMajor = "Illusion"}
        {71..75 -contains $_}  {$StaffMajor = "Necromancy"}
        {76..80 -contains $_}  {$StaffMajor = "Transmutation"}
        {81..85 -contains $_}  {$StaffMajor = "Earth and stone"}
        {86..90 -contains $_}  {$StaffMajor = "Woodlands"}
        {91..95 -contains $_}  {$StaffMajor = "Life"}
        {96..98 -contains $_}  {$StaffMajor = "Passage"}
        {99..100 -contains $_} {$StaffMajor = "Power"}
    } #End Switch
    return $StaffMajor
} #End function Get-DNDStaffMajor

Function Get-DNDWandMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..05 -contains $_}  {$WandMinor = "zero"}
        {06..60 -contains $_}  {$WandMinor = "first"}
        {61..100 -contains $_} {$WandMinor = "second"}
    } #End Switch
    return $WandMinor
} #End function Get-DNDWandMinor

Function Get-DNDWandMedium {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..60 -contains $_}  {$WandMedium = "second"}
        {61..100 -contains $_} {$WandMedium = "third"}
    } #End Switch
    return $WandMedium
} #End function Get-DNDWandMedium

Function Get-DNDWandMajor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {01..60 -contains $_}  {$WandMajor = "third"}
        {61..100 -contains $_} {$WandMajor = "fourth"}
    } #End Switch
    return $WandMajor
} #End function Get-DNDWandMajor

Function Get-DNDWondrousItemMinor {
    $WondrousItemList = @(
        "Feather token, anchor"
        "Universal solvent"
        "Elixir of love"
        "Unguent of timelessness"
        "Feather token, fan"
        "Dust of tracelessness"
        "Elixir of hiding"
        "Elixir of tumbling"
        "Elixir of swimming"
        "Elixir of vision"
        "Silversheen"
        "Feather token, bird"
        "Feather token, tree"
        "Feather token, swan boat"
        "Elixir of truth"
        "Feather token, whip"
        "Dust of dryness"
        "Hand of the mage"
        "Bracers of armor +1"
        "Cloak of resistance +1"
        "Pearl of power, 1st-level spell"
        "Phylactery of faithfulness"
        "Salve of slipperiness"
        "Elixir of fire breath"
        "Pipes of the sewers"
        "Dust of illusion"
        "Brooch of shielding"
        "Necklace of fireballs type I"
        "Dust of appearance"
        "Hat of disguise"
        "Pipes of sounding"
        "Efficient quiver"
        "Amulet of natural armor +1"
        "Handy haversack"
        "Horn of fog"
        "Elemental gem"
        "Robe of bones"
        "Sovereign glue"
        "Bag of holding type I"
        "Boots of elvenkind"
        "Boots of the winterlands"
        "Candle of truth"
        "Cloak of elvenkind"
        "Eyes of the eagle"
        "Goggles of minute seeing"
        "Scarab, golembane"
        "Necklace of fireballs type II"
        "Stone of alarm"
        "Bead of force"
        "Chime of opening"
        "Horseshoes of speed"
        "Rope of climbing"
        "Bag of tricks, gray"
        "Dust of disappearance"
        "Lens of detection"
        "Vestment, druid's"
        "Figurine of wondrous power, silver raven"
        "Belt of giant strength +2"
        "Belt of incredible dexterity +2"
        "Belt of mighty constitution +2"
        "Bracers of armor +2"
        "Cloak of resistance +2"
        "Gloves of arrow snaring"
        "Headband of alluring charisma +2"
        "Headband of inspired wisdom +2"
        "Headband of vast intelligence +2"
        "Ioun stone, clear spindle"
        "Restorative ointment"
        "Marvelous pigments"
        "Pearl of power, 2nd-level spell"
        "Stone salve"
        "Necklace of fireballs type III"
        "Circlet of persuasion"
        "Slippers of spider climbing"
        "Incense of meditation"
        "Amulet of mighty fists +1"
        "Bag of holding type II"
        "Bracers of archery, lesser"
        "Ioun stone, dusty rose prism"
        "Helm of comprehend languages and read magic"
        "Vest of escape"
        "Eversmoking bottle"
        "Sustaining spoon"
        "Necklace of fireballs type IV"
        "Boots of striding and springing"
        "Wind fan"
        "Necklace of fireballs type V"
        "Horseshoes of a zephyr"
        "Pipes of haunting"
        "Gloves of swimming and climbing"
        "Crown of blasting, minor"
        "Horn of goodness/evil"
        "Robe of useful items"
        "Boat, folding"
        "Cloak of the manta ray"
        "Bottle of air"
        "Bag of holding type III"
        "Periapt of health"
        "Boots of levitation"
        "Harp of charming"
    ) #End ItemList
    
    $WondrousItemMinor = $WondrousItemList | Get-Random
    return $WondrousItemMinor
} #End function Get-DNDWondrousItemMinor

Function Get-DNDWondrousItemMedium {
    $WondrousItemList = @(
        "Amulet of natural armor +2"
        "Golem manual, flesh"
        "Hand of glory"
        "Ioun stone, deep red sphere"
        "Ioun stone, incandescent blue sphere"
        "Ioun stone, pale blue rhomboid"
        "Ioun stone, pink and green sphere"
        "Ioun stone, pink rhomboid"
        "Ioun stone, scarlet and blue sphere"
        "Deck of illusions"
        "Necklace of fireballs type VI"
        "Candle of invocation"
        "Robe of blending"
        "Bag of tricks, rust"
        "Necklace of fireballs type VII"
        "Bracers of armor +3"
        "Cloak of resistance +3"
        "Decanter of endless water"
        "Necklace of adaptation"
        "Pearl of power, 3rd-level spell"
        "Figurine of wondrous power, serpentine owl"
        "Strand of prayer beads, lesser"
        "Bag of holding type IV"
        "Belt of physical might +2"
        "Figurine of wondrous power, bronze griffon"
        "Figurine of wondrous power, ebony fly"
        "Glove of storing"
        "Headband of mental prowess +2"
        "Ioun stone, dark blue rhomboid"
        "Cape of the mountebank"
        "Phylactery of negative channeling"
        "Phylactery of positive channeling"
        "Gauntlet of rust"
        "Boots of speed"
        "Goggles of night"
        "Golem manual, clay"
        "Medallion of thoughts"
        "Blessed book"
        "Gem of brightness"
        "Lyre of building"
        "Robe, Monk's"
        "Cloak of arachnida"
        "Belt of dwarvenkind"
        "Periapt of wound closure"
        "Pearl of the sirines"
        "Figurine of wondrous power, onyx dog"
        "Bag of tricks, tan"
        "Belt of giant strength +4"
        "Belt of incredible dexterity +4"
        "Belt of mighty constitution +4"
        "Belt of physical perfection +2"
        "Boots, winged"
        "Bracers of armor +4"
        "Cloak of resistance +4"
        "Headband of alluring charisma +4"
        "Headband of inspired wisdom +4"
        "Headband of mental superiority +2"
        "Headband of vast intelligence +4"
        "Pearl of power, 4th-level spell"
        "Scabbard of keen edges"
        "Figurine of wondrous power, golden lions"
        "Chime of interruption"
        "Broom of flying"
        "Figurine of wondrous power, marble elephant"
        "Amulet of natural armor +3"
        "Ioun stone, iridescent spindle"
        "Bracelet of friends"
        "Amulet of mighty fists +2"
        "Carpet of flying, 5 ft. by 5 ft."
        "Horn of blasting"
        "Ioun stone, pale lavender ellipsoid"
        "Ioun stone, pearly white spindle"
        "Portable hole"
        "Stone of good luck (luckstone)"
        "Figurine of wondrous power, ivory goats"
        "Rope of entanglement"
        "Golem manual, stone"
        "Mask of the skull"
        "Mattock of the titans"
        "Crown of blasting, major"
        "Cloak of displacement, minor"
        "Helm of underwater action"
        "Bracers of archery, greater"
        "Bracers of armor +5"
        "Cloak of resistance +5"
        "Eyes of doom"
        "Pearl of power, 5th-level spell"
        "Maul of the titans"
        "Cloak of the bat"
        "Iron bands of binding"
        "Cube of frost resistance"
        "Helm of telepathy"
        "Periapt of proof against poison"
        "Robe of scintillating colors"
        "Manual of bodily health +1"
        "Manual of gainful exercise +1"
        "Manual of quickness in action +1"
        "Tome of clear thought +1"
        "Tome of leadership and influence +1"
        "Tome of understanding +1"
    ) #End WondrousItemList
    
    $WondrousItemMedium = $WondrousItemList | Get-Random
    return $WondrousItemMedium
} #End function Get-DNDWondrousItemMedium

Function Get-DNDWondrousItemMajor {
    $WondrousItemList = @(
        "Dimensional shackles"
        "Figurine of wondrous power, obsidian steed"
        "Drums of panic"
        "Ioun stone, orange prism"
        "Ioun stone, pale green prism"
        "Lantern of revealing"
        "Amulet of natural armor +4"
        "Amulet of proof against detection and location"
        "Carpet of flying, 5 ft. by 10 ft."
        "Golem manual, iron"
        "Belt of giant strength +6"
        "Belt of incredible dexterity +6"
        "Belt of mighty constitution +6"
        "Bracers of armor +6"
        "Headband of alluring charisma +6"
        "Headband of inspired wisdom +6"
        "Headband of vast intelligence +6"
        "Ioun stone, vibrant purple prism"
        "Pearl of power, 6th-level spell"
        "Scarab of protection"
        "Belt of physical might +4"
        "Headband of mental prowess +4"
        "Ioun stone, lavender and green ellipsoid"
        "Ring gates"
        "Crystal ball"
        "Golem manual, stone guardian"
        "Amulet of mighty fists +3"
        "Strand of prayer beads"
        "Orb of storms"
        "Boots of teleportation"
        "Bracers of armor +7"
        "Pearl of power, 7th-level spell"
        "Amulet of natural armor +5"
        "Cloak of displacement, major"
        "Crystal ball with see invisibility"
        "Horn of Valhalla"
        "Crystal ball with detect thoughts"
        "Wings of flying"
        "Cloak of etherealness"
        "Instant fortress"
        "Manual of bodily health +2"
        "Manual of gainful exercise +2"
        "Manual of quickness in action +2"
        "Tome of clear thought +2"
        "Tome of leadership and influence +2"
        "Tome of understanding +2"
        "Eyes of charming"
        "Robe of stars"
        "Carpet of flying, 10 ft. by 10 ft."
        "Darkskull"
        "Cube of force"
        "Belt of physical perfection +4"
        "Bracers of armor +8"
        "Headband of mental superiority +4"
        "Pearl of power, 8th-level spell"
        "Crystal ball with telepathy"
        "Horn of blasting, greater"
        "Pearl of power, two spells"
        "Helm of teleportation"
        "Gem of seeing"
        "Robe of the archmagi"
        "Mantle of faith"
        "Amulet of mighty fists +4"
        "Crystal ball with true seeing"
        "Pearl of power, 9th-level spell"
        "Well of many worlds"
        "Manual of bodily health +3"
        "Manual of gainful exercise +3"
        "Manual of quickness in action +3"
        "Tome of clear thought +3"
        "Tome of leadership and influence +3"
        "Tome of understanding +3"
        "Apparatus of the crab"
        "Belt of physical might +6"
        "Headband of mental prowess +6"
        "Mantle of spell resistance"
        "Mirror of opposition"
        "Strand of prayer beads, greater"
        "Manual of bodily health +4"
        "Manual of gainful exercise +4"
        "Manual of quickness in action +4"
        "Tome of clear thought +4"
        "Tome of leadership and influence +4"
        "Tome of understanding +4"
        "Amulet of the planes"
        "Robe of eyes"
        "Amulet of mighty fists +5"
        "Helm of brilliance"
        "Manual of bodily health +5"
        "Manual of gainful exercise +5"
        "Manual of quickness in action +5"
        "Tome of clear thought +5"
        "Tome of leadership and influence +5"
        "Tome of understanding +5"
        "Belt of physical perfection +6"
        "Headband of mental superiority +6"
        "Efreeti bottle"
        "Cubic gate"
        "Iron flask"
        "Mirror of life trapping"
    ) #End WondrousItemList
    
    $WondrousItemMajor = $WondrousItemList | Get-Random
    return $WondrousItemMajor
} #End function Get-DNDWondrousItemMajor

#endregion define functions


#-------------------------
#region Header
#-------------------------
Clear-Host

#Give feedback to user when $ItemPower isn't specified
If ($ItemPower -notin @("minor","medium","major")) {
    Write-Host "No correct item power specified, defaulting to Minor"
    $ItemPower = "minor"
}

#Give an overview of what is going to happen next
If ($Number -eq 1) {
    Write-Host "You will get $Number $ItemPower item."
} Else {
    Write-Host "You will get $Number $ItemPower items"
}

#Inform user that only a specified item type is used
If ($Type -in @("armor or shield","weapon","potion","ring","rod","scroll","staff","wand","wondrous item")) {
    Write-Host "You chose to only generate items of the type " -NoNewline
    Write-Host "$Type" -ForegroundColor Cyan
}
#endregion header

#-------------------------
#region main loop
#-------------------------
#Run through the script for a specified number of times
1..$Number | ForEach-Object {

    #Define / clear variables
    $Item = @{
        BaseItem = ""
        SpecialAbility = @()
        ItemBonus = ""
        WandCharges = ""
        SpecificItem = ""
    }
    $Die = 0


    #-------------------------
    #region first roll: determine item type
    #-------------------------
    #Check if the Type parameter is filled with a usable value and only do the first roll if it isn't
    If ($Type -notin @("armor or shield","weapon","potion","ring","rod","scroll","staff","wand","wondrous item")) {
        #Roll the die and get the appropriate item type from the specified table
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 for the item type. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRandomItemTypeMinor -Dieroll $Die}
        If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRandomItemTypeMedium -Dieroll $Die}
        If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRandomItemTypeMajor -Dieroll $Die}
        
        #User feedback
        If ($Manual -eq $True) {
            Write-Host "Your itemtype is: " -NoNewline
            Write-Host "$($Item.BaseItem)" -ForegroundColor Cyan
        }
    } Else {
        $Item.BaseItem = $Type
    } #End else    

    #endregion eerste rol
    
    
    #-------------------------
    #region second roll and further: determine item
    #-------------------------
    
    #-------------------------
    #region armors and shields
    #-------------------------
    If ($Item.BaseItem -eq "armor or shield") {
        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 the kind of armor or shield. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRandomArmorMinor -Dieroll $Die}
        If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRandomArmorMedium -Dieroll $Die}
        If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRandomArmorMajor -Dieroll $Die}
        
        #User feedback
        If ($Manual -eq $True) {
            Write-Host "Je itemtype is: " -NoNewline
            Write-Host "$($Item.BaseItem)" -ForegroundColor Cyan #Yellow
        }
    
        #In lucky cases, roll extra for special abilities
        While ($Item.BaseItem -eq "special ability and roll again") {
            If ($Manual -eq $True) {Write-Host "Lucky! Roll twice again"}
            $I = 1
    
            #Get dieroll for the armor type
            If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
            If ($Manual -eq $True) {Do {$Die = Read-Host "Roll  1d100 again for the armor or shield. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
            
            #Determine armor type
            If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRandomArmorMinor -Dieroll $Die}
            If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRandomArmorMedium -Dieroll $Die}
            If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRandomArmorMajor -Dieroll $Die}
    
            #Get dieroll for the armor ability
            If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
            If ($Manual -eq $True) {$Die = Read-Host "Roll 1d100 for the ability. what is the result of the die roll?"}
    
            #Determine armor ability
            If ($ItemPower -eq "minor")  {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMinor -Dieroll $Die}
            If ($ItemPower -eq "medium") {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMedium -Dieroll $Die}
            If ($ItemPower -eq "major")  {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMajor -Dieroll $Die}
    
            #In very lucky cases, roll extra for more special abilities
            If ($Item.SpecialAbility -eq "roll twice again") {
                $Rolls = 2
                If ($Manual -eq $True) {Write-Host "This is your lucky day! Roll twice again for special abilities!"}
    
                #Keep rolling until there are no more rerolls
                While ($Rolls -ne 0) {
                    #Get dieroll for the armor ability 1
                    If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
                    If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 for the next ability. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
                    If ($Die -eq 100) {$Rolls += 2} #Rolling 100 means getting two extra rolls
    
                    #Determine extra ability 
                    If ($ItemPower -eq "minor")  {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMinor -Dieroll $Die; $Rolls -= 1}
                    If ($ItemPower -eq "medium") {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMedium -Dieroll $Die; $Rolls -= 1 }
                    If ($ItemPower -eq "major")  {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMajor -Dieroll $Die; $Rolls -= 1 }
                
                } #End while rolls -ne 0
    
            } #End while roll twice again
    
            #Clean up the array from temporary entries
            $Item.SpecialAbility = $Item.SpecialAbility | Where-Object {$_ -ne "roll twice again"}
                
        } #End while special ability and roll again
    
        If ($Item.BaseItem -eq "specific armor") {
            #Get dieroll for the specific armor
            If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
            If ($Manual -eq $True) {Do {$Die = Read-Host "You get a specific armor. Rol 1d100. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
    
            #Determine the specific armor
            If ($ItemPower -eq "minor")  {$Item.SpecificItem = (Get-DNDSpecificArmorMinor -Dieroll $Die)}
            If ($ItemPower -eq "medium") {$Item.SpecificItem = (Get-DNDSpecificArmorMedium -Dieroll $Die)}
            If ($ItemPower -eq "major")  {$Item.SpecificItem = (Get-DNDSpecificArmorMajor -Dieroll $Die)}
        } elseIf ($Item.BaseItem -eq "specific shield") {
            #Get dieroll for the specific shield
            If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
            If ($Manual -eq $True) {Do {$Die = Read-Host "You get a specific shield. Rol 1d100. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
    
            #Determine the specific shield
            If ($ItemPower -eq "minor")  {$Item.SpecificItem = (Get-DNDSpecificShieldMinor -Dieroll $Die) }
            If ($ItemPower -eq "medium") {$Item.SpecificItem = (Get-DNDSpecificShieldMedium -Dieroll $Die) }
            If ($ItemPower -eq "major")  {$Item.SpecificItem = (Get-DNDSpecificShieldMajor -Dieroll $Die) }
        } else {
            #Extract the item bonus from the base item
            If ($Item.BaseItem -like "*+1*") {$item.ItemBonus = "+1"}
            If ($Item.BaseItem -like "*+2*") {$item.ItemBonus = "+2"}
            If ($Item.BaseItem -like "*+3*") {$item.ItemBonus = "+3"}
            If ($Item.BaseItem -like "*+4*") {$item.ItemBonus = "+4"}
            If ($Item.BaseItem -like "*+5*") {$item.ItemBonus = "+5"}
        
            #Replace the base armor with a specified armor type
            If ($Item.BaseItem -like "*armor*") {$item.BaseItem = Get-DNDRandomArmorType}
            If ($Item.BaseItem -like "*shield*") {$item.BaseItem = Get-DNDRandomShieldType}
        }
    
    } #Endif armor of shield
    
    #endregion armors and shields
    
    
    #-------------------------
    #region weapons
    #-------------------------
    If ($Item.BaseItem -eq "weapon") {
        #Determine if the item will be a melee or a ranged weapon
        $MeleeOrRangedRoll = Get-Random -Minimum 1 -Maximum 74
        If ($MeleeOrRangedRoll -in 1..55) {
            $Item.ItemRange = "melee"
        } else {
            $Item.ItemRange = "ranged"
        }

        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 the kind of weapon. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($Item.ItemRange -eq "melee") {
            If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDMeleeWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMinor -Dieroll $Die}
            If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDMeleeWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMedium -Dieroll $Die}
            If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDMeleeWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMajor -Dieroll $Die}
        }
        If ($Item.ItemRange -eq "ranged") {
            If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRangedWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMinor -Dieroll $Die}
            If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRangedWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMedium -Dieroll $Die}
            If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRangedWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMajor -Dieroll $Die}
        }

        #User feedback
        If ($Manual -eq $True -and $Item.ItemBonus -ne "Specific Weapon") {
            Write-Host "Je itemtype is: " -NoNewline
            Write-Host "$($Item.BaseItem)" -ForegroundColor Cyan
        }

        #In lucky cases, roll extra for special abilities
        While ($Item.ItemBonus -eq "special ability and roll again") {
            If ($Manual -eq $True) {Write-Host "Lucky! Roll twice again"}
            $I = 1
    
            #Get dieroll for the weapon type
            If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
            If ($Manual -eq $True) {Do {$Die = Read-Host "Roll  1d100 again for the weapon. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
            
            #Determine weapon type
            If ($Item.ItemRange -eq "melee") {
                If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDMeleeWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMinor -Dieroll $Die}
                If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDMeleeWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMedium -Dieroll $Die}
                If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDMeleeWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMajor -Dieroll $Die}
            }
            If ($Item.ItemRange -eq "ranged") {
                If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRangedWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMinor -Dieroll $Die}
                If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRangedWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMedium -Dieroll $Die}
                If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRangedWeaponType; $Item.ItemBonus = Get-DNDRandomWeaponMajor -Dieroll $Die}
            }

            #Get dieroll for the weapon ability
            If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
            If ($Manual -eq $True) {$Die = Read-Host "Roll 1d100 for the ability. what is the result of the die roll?"}
    
            #Determine weapon ability
            If ($Item.ItemRange -eq "melee") {
                If ($ItemPower -eq "minor")  {$Item.SpecialAbility += Get-DNDRandomMeleeWeaponAbilityMinor -Dieroll $Die}
                If ($ItemPower -eq "medium") {$Item.SpecialAbility += Get-DNDRandomMeleeWeaponAbilityMedium -Dieroll $Die}
                If ($ItemPower -eq "major")  {$Item.SpecialAbility += Get-DNDRandomMeleeWeaponAbilityMajor -Dieroll $Die}
            }    
            If ($Item.ItemRange -eq "ranged") {
                If ($ItemPower -eq "minor")  {$Item.SpecialAbility += Get-DNDRandomRangedWeaponAbilityMinor -Dieroll $Die}
                If ($ItemPower -eq "medium") {$Item.SpecialAbility += Get-DNDRandomRangedWeaponAbilityMedium -Dieroll $Die}
                If ($ItemPower -eq "major")  {$Item.SpecialAbility += Get-DNDRandomRangedWeaponAbilityMajor -Dieroll $Die}
            }

            #In very lucky cases, roll extra for more special abilities
            If ($Item.SpecialAbility -eq "Roll again twice") {
                $Rolls = 2
                If ($Manual -eq $True) {Write-Host "This is your lucky day! Roll twice again for special abilities!"}
    
                #Keep rolling until there are no more rerolls
                While ($Rolls -ne 0) {
                    #Get dieroll for the Weapon ability 1
                    If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
                    If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 for the next ability. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
                    If ($Die -eq 100) {$Rolls += 2} #Rolling 100 means getting two extra rolls (one of which is always done, so only +1 to the counter)
    
                    #Determine extra ability 
                    If ($Item.ItemRange -eq "melee") {
                        If ($ItemPower -eq "minor")  {$Item.SpecialAbility += Get-DNDRandomMeleeWeaponAbilityMinor -Dieroll $Die; $Rolls -= 1}
                        If ($ItemPower -eq "medium") {$Item.SpecialAbility += Get-DNDRandomMeleeWeaponAbilityMedium -Dieroll $Die; $Rolls -= 1}
                        If ($ItemPower -eq "major")  {$Item.SpecialAbility += Get-DNDRandomMeleeWeaponAbilityMajor -Dieroll $Die; $Rolls -= 1}
                    }    
                    If ($Item.ItemRange -eq "ranged") {
                        If ($ItemPower -eq "minor")  {$Item.SpecialAbility += Get-DNDRandomRangedWeaponAbilityMinor -Dieroll $Die; $Rolls -= 1}
                        If ($ItemPower -eq "medium") {$Item.SpecialAbility += Get-DNDRandomRangedWeaponAbilityMedium -Dieroll $Die; $Rolls -= 1}
                        If ($ItemPower -eq "major")  {$Item.SpecialAbility += Get-DNDRandomRangedWeaponAbilityMajor -Dieroll $Die; $Rolls -= 1}
                    }
                
                } #End while rolls -ne 0
    
            } #End while Roll again twice
    
            #Clean up the array from temporary entries
            $Item.SpecialAbility = $Item.SpecialAbility | Where-Object {$_ -ne "Roll again twice"}
                
        } #End while special ability and roll again

        #Roll for what specific weapon
        If ($Item.ItemBonus -eq "Specific weapon") {
            #Get dieroll for the specific weapon
            If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
            If ($Manual -eq $True) {Do {$Die = Read-Host "You get a specific weapon. Rol 1d100. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
    
            #Determine the specific weapon
            If ($ItemPower -eq "minor")  {$Item.SpecificItem = (Get-DNDSpecificWeaponMinor -Dieroll $Die)}
            If ($ItemPower -eq "medium") {$Item.SpecificItem = (Get-DNDSpecificWeaponMedium -Dieroll $Die)}
            If ($ItemPower -eq "major")  {$Item.SpecificItem = (Get-DNDSpecificWeaponMajor -Dieroll $Die)}
        } #Endif specific weapon

    } #Endif weapon

    #endregion weapons
    
    
    #-------------------------
    #region potions
    #-------------------------
    If ($Item.BaseItem -eq "potion") {
        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 for what kind of potion. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "minor")  {$Item.BaseItem = "Potion with " + (Get-DNDPotionMinor -Dieroll $Die) + " level spell"}
        If ($ItemPower -eq "medium") {$Item.BaseItem = "Potion with " + (Get-DNDPotionMedium -Dieroll $Die) + " level spell"}
        If ($ItemPower -eq "major")  {$Item.BaseItem = "Potion with " + (Get-DNDPotionMajor -Dieroll $Die) + " level spell"}
    }
    #endregion potions
    
    
    #-------------------------
    #region rings
    #-------------------------
    If ($Item.BaseItem -eq "ring") {
        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 for what kind of ring ring. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "minor")  {$Item.BaseItem = "Ring of " + (Get-DNDRingMinor -Dieroll $Die)}
        If ($ItemPower -eq "medium") {$Item.BaseItem = "Ring of " + (Get-DNDRingMedium -Dieroll $Die)}
        If ($ItemPower -eq "major")  {$Item.BaseItem = "Ring of " + (Get-DNDRingMajor -Dieroll $Die)}
    }
    #endregion rings
    
    
    #-------------------------
    #region rods
    #-------------------------
    If ($Item.BaseItem -eq "rod") {
        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 what kind of rod. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "medium") {$Item.BaseItem = "Rod of " + (Get-DNDRodMedium -Dieroll $Die)}
        If ($ItemPower -eq "major")  {$Item.BaseItem = "Rod of " + (Get-DNDRodMajor -Dieroll $Die)}
    }
    #endregion rods
    
    
    #-------------------------
    #region scrolls
    #-------------------------
    If ($Item.BaseItem -eq "scroll") {
        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 what kind of scroll. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "minor")  {$Item.BaseItem = "Scroll with " + (Get-DNDScrollMinor -Dieroll $Die) + " level spell"}
        If ($ItemPower -eq "medium") {$Item.BaseItem = "Scroll with " + (Get-DNDScrollMedium -Dieroll $Die) + " level spell"}
        If ($ItemPower -eq "major")  {$Item.BaseItem = "Scroll with " + (Get-DNDScrollMajor -Dieroll $Die) + " level spell"}
    }
    #endregion scrolls
    
    
    #-------------------------
    #region staves
    #-------------------------
    If ($Item.BaseItem -eq "staff") {
        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 what kind of staff. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "medium") {$Item.BaseItem = "Staff of " + (Get-DNDStaffMedium -Dieroll $Die)}
        If ($ItemPower -eq "major")  {$Item.BaseItem = "Staff of " + (Get-DNDStaffMajor -Dieroll $Die)}
    }
    #endregion staves
    
    
    #-------------------------
    #region wands
    #-------------------------
    If ($Item.BaseItem -eq "wand") {
        #Search through the table of items, getting the correct table from the previous roll
        If ($Manual -eq $False) {$Die = Get-Random -Minimum 1 -Maximum 101}
        If ($Manual -eq $True) {Do {$Die = Read-Host "Roll 1d100 what kind of wand. what is the result of the die roll?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        If ($ItemPower -eq "minor")  {$Item.BaseItem = "Wand with " + (Get-DNDScrollMinor -Dieroll $Die) + " level spell"}
        If ($ItemPower -eq "medium") {$Item.BaseItem = "Wand with " + (Get-DNDScrollMedium -Dieroll $Die) + " level spell"}
        If ($ItemPower -eq "major")  {$Item.BaseItem = "Wand with " + (Get-DNDScrollMajor -Dieroll $Die) + " level spell"}
        $Item.WandCharges = Get-Random -Minimum 1 -Maximum 51
    }
    #endregion wands
    
    
    #-------------------------
    #region wondrous items
    #-------------------------
    If ($Item.BaseItem -eq "wondrous item") {
        If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDWondrousItemMinor}
        If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDWondrousItemMedium}
        If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDWondrousItemMajor}
    }
    #endregion wondrous items
    
    #endregion tweede rol
    
    
    #-------------------------
    #region user feedback
    #-------------------------
    #If a specific item has been generated, overwrite possible bogus itemstats here
    If ($Item.SpecificItem) {
        $Item.BaseItem = $Item.SpecificItem
        $Item.SpecialAbility = ""
        $Item.ItemBonus = ""
    }

    #Remove duplicate abilities from the list of special abilities
    $Item.SpecialAbility = $Item.SpecialAbility | select -uniq
        
    #Extract the item bonus from the base item
    If ($Item.BaseItem -like "*+1*") {$item.ItemBonus = "+1"}
    If ($Item.BaseItem -like "*+2*") {$item.ItemBonus = "+2"}
    If ($Item.BaseItem -like "*+3*") {$item.ItemBonus = "+3"}
    If ($Item.BaseItem -like "*+4*") {$item.ItemBonus = "+4"}
    If ($Item.BaseItem -like "*+5*") {$item.ItemBonus = "+5"}
        
    #Create the final item out of all possible different pieces
    $EndItem = $($Item.BaseItem)
    If ($Item.ItemBonus) {$EndItem = $($Item.BaseItem) + " $($Item.ItemBonus)"}
    If ($Item.SpecialAbility) {$EndItem = $($Item.BaseItem) +  " with " + (@($Item.SpecialAbility) -join ", ")}
    If ($Item.WandCharges) {$EndItem = $($Item.BaseItem) + " and $($Item.WandCharges) charges"}
    Write-Host "$EndItem" -ForegroundColor Green
    
    #endregion user feedback
    
} #End main loop

#Just a blank like to make it look better
Write-Host "" 

#endregion main loop

