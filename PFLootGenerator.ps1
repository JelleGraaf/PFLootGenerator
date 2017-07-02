[BOOL]$Automatic = $True #To specify whether the script should rol the dice, or the user
$ItemPower = "unspecified" #To later set to Minor, Medium or Major
$Item = @{
    BaseItem = ""
    SpecialAbility = @()
}
$Die = 0

#-------------------------
#region define functions
#-------------------------
Function Get-DNDRandomItemTypeMinor {
    param (
        $Dieroll
        )

    Switch ($Dieroll) {
        {1..4 -contains $_}    {$ItemType = "armor or shield" }
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
        {66..68 -contains $_}  {$ItemType = "stave"}
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
        {56..75 -contains $_}  {$ItemType = "stave"}
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
        "Hide"
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
        "Vestment, druid’s"
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
        "Robe, Monk’s"
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
        "Item Market Price"
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
#region set-up questions
#-------------------------
Clear-Host

#Ask user to automatically roll the dice by the script, or do it themself
do {
    $DiceChoice = Read-Host "Wil je graag zelf dobbelstenen rollen (Y/N)?"
    if ($DiceChoice -eq "Y") {$Automatic = $False}
    if ($DiceChoice -eq "N") {$Automatic = $True}
} Until ($DiceChoice -eq "Y" -or $DiceChoice -eq "N")

#Ask user to select minor, medium or major item
do {$ItemPower = Read-Host "Wil je een minor, medium of major item?"
} Until ($ItemPower -eq "minor" -or $ItemPower -eq "medium" -or $ItemPower -eq "major")

#endregion set-up questions

#-------------------------
#region eerste rol: bepalen van item type
#-------------------------
#Roll the die and get the appropriate item type from the specified table
If ($Automatic -eq $True) {$Die = Get-Random -Minimum 1 -Maximum 101; Write-Host "Je dobbelsteenrol voor het itemtype was " -NoNewline; Write-Host "$Die. " -ForegroundColor Yellow -NoNewline }
If ($Automatic -eq $False) {Do {$Die = Read-Host "Rol 1d100 voor het itemtype. Wat rolde je?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given

If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRandomItemTypeMinor -Dieroll $Die}
If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRandomItemTypeMedium -Dieroll $Die}
If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRandomItemTypeMajor -Dieroll $Die}

#User feedback
Write-Host "Je itemtype is: " -NoNewline
Write-Host "$($Item.BaseItem)" -ForegroundColor Cyan
#endregion eerste rol


#-------------------------
#region tweede rol en verder: item bepalen
#-------------------------
#Search through the table of items, getting the correct table from the previous roll
If ($Automatic -eq $True) {$Die = Get-Random -Minimum 1 -Maximum 101; Write-Host "Je dobbelsteenrol was " -NoNewline; Write-Host "$Die. " -ForegroundColor Yellow -NoNewline }
If ($Automatic -eq $False) {Do {$Die = Read-Host "Rol 1d100. Wat rolde je?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given

#-------------------------
#region armors and shields
#-------------------------
If ($Item.BaseItem -eq "armor or shield") {
    If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRandomArmorMinor -Dieroll $Die}
    If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRandomArmorMedium -Dieroll $Die}
    If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRandomArmorMajor -Dieroll $Die}

    #User feedback
    Write-Host "Je itemtype is: " -NoNewline
    Write-Host "$($Item.BaseItem)" -ForegroundColor Cyan #Yellow

    #In lucky cases, roll extra for special abilities
    While ($Item.BaseItem -eq "special ability and roll again") {
        Write-Host "Je hebt gelukt, je mag twee keer extra rollen!"
        $I = 1

        #Get dieroll for the armor type
        If ($Automatic -eq $True) {$Die = Get-Random -Minimum 1 -Maximum 101; Write-Host "Je dobbelsteenrol voor het armor of shield was " -NoNewline; Write-Host "$Die. " -ForegroundColor Yellow }
        If ($Automatic -eq $False) {Do {$Die = Read-Host "Rol nogmaals 1d100 voor het armor of shield. Wat rolde je?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
        
        #Determine armor type
        If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDRandomArmorMinor -Dieroll $Die}
        If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDRandomArmorMedium -Dieroll $Die}
        If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDRandomArmorMajor -Dieroll $Die}

        #Get dieroll for the armor ability
        If ($Automatic -eq $True) {$Die = Get-Random -Minimum 1 -Maximum 101; Write-Host "Je dobbelsteenrol voor de ability was " -NoNewline; Write-Host "$Die. " -ForegroundColor Yellow  }
        If ($Automatic -eq $False) {$Die = Read-Host "Rol 1d100 voor de ability. Wat rolde je?"}

        #Determine armor ability
        If ($ItemPower -eq "minor")  {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMinor -Dieroll $Die}
        If ($ItemPower -eq "medium") {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMedium -Dieroll $Die}
        If ($ItemPower -eq "major")  {$Item.SpecialAbility += Get-DNDRandomArmorAbilityMajor -Dieroll $Die}

        #In very lucky cases, roll extra for more special abilities
        If ($Item.SpecialAbility -eq "roll twice again") {
            $Rolls = 2
            Write-Host "Jeetje, it's your lucky day! Je mag nóg eens extra rollen voor special abilities!"

            #Keep rolling until there are no more rerolls
            While ($Rolls -ne 0) {
                #Get dieroll for the armor ability 1
                If ($Automatic -eq $True) {$Die = Get-Random -Minimum 1 -Maximum 101; Write-Host "Je dobbelsteenrol voor de volgende ability was " -NoNewline; Write-Host "$Die. " -ForegroundColor Yellow -NoNewline }
                If ($Automatic -eq $False) {Do {$Die = Read-Host "Rol 1d100 voor de volgende ability. Wat rolde je?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given
                If ($Die -eq 100) {$Rolls += 2} #Rolling 100 means getting two extra rolls (one of which is always done, so only +1 to the counter)

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
        If ($Automatic -eq $True) {$Die = Get-Random -Minimum 1 -Maximum 101; Write-Host "Je krijgt een specifiek pantser. Je dobbelsteenrol hiervoor is " -NoNewline; Write-Host "$Die. " -ForegroundColor Yellow -NoNewline }
        If ($Automatic -eq $False) {Do {$Die = Read-Host "Je krijgt een specifiek pantser. Rol 1d100. Wat rolde je?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given

        #Determine the specific armor
        If ($ItemPower -eq "minor")  {$Item.add("SpecificItem", (Get-DNDSpecificArmorMinor -Dieroll $Die))}
        If ($ItemPower -eq "medium") {$Item.SpecificItem = (Get-DNDSpecificArmorMedium -Dieroll $Die)}
        If ($ItemPower -eq "major")  {$Item.SpecificItem = (Get-DNDSpecificArmorMajor -Dieroll $Die)}
    } #Endif specific armor

    If ($Item.BaseItem -eq "specific shield") {
        #Set this thing to use at end presentation
        
        #Get dieroll for the specific shield
        If ($Automatic -eq $True) {$Die = Get-Random -Minimum 1 -Maximum 101; Write-Host "Je krijgt een specifiek schild. Je dobbelsteenrol hiervoor is " -NoNewline; Write-Host "$Die. " -ForegroundColor Yellow -NoNewline }
        If ($Automatic -eq $False) {Do {$Die = Read-Host "Je krijgt een specifiek schild. Rol 1d100. Wat rolde je?"} While ($Die -notin 1..100)} #Keep asking for input until a value between 1 and 100 is given

        #Determine the specific shield
        If ($ItemPower -eq "minor")  {$Item.SpecificItem = (Get-DNDSpecificShieldMinor -Dieroll $Die) }
        If ($ItemPower -eq "medium") {$Item.SpecificItem = (Get-DNDSpecificShieldMedium -Dieroll $Die) }
        If ($ItemPower -eq "major")  {$Item.SpecificItem = (Get-DNDSpecificShieldMajor -Dieroll $Die) }
    } #Endif specific shield

} #Endif armor of shield


#endregion armors and shields

#-------------------------
#region weapons
#-------------------------
#endregion weapons

#-------------------------
#region potions
#-------------------------
#endregion potions

#-------------------------
#region rings
#-------------------------
#endregion rings

#-------------------------
#region scrolls
#-------------------------
#endregion scrolls

#-------------------------
#region wands
#-------------------------
#endregion wands

#-------------------------
#region wondrous items
#-------------------------
If ($Item.BaseItem -eq "wondrous item") {
    If ($ItemPower -eq "minor")  {$Item.BaseItem = Get-DNDWondrousItemMinor}
    If ($ItemPower -eq "medium") {$Item.BaseItem = Get-DNDWondrousItemMedium}
    If ($ItemPower -eq "major")  {$Item.BaseItem = Get-DNDWondrousItemMajor}

#################################################################################FEEDBACK?
#endregion wondrous items



#endregion tweede rol

#-------------------------
#region user feedback
#-------------------------

If ($Item.SpecificItem) {
    Write-Host "Je unieke item is: " -NoNewline
    Write-Host $Item.SpecificItem -ForegroundColor Green
    Exit
}

#Extract the item bonus from the base item
If ($Item.BaseItem -like "*+1*") {$item.ItemBonus = "+1"}
If ($Item.BaseItem -like "*+2*") {$item.ItemBonus = "+2"}
If ($Item.BaseItem -like "*+3*") {$item.ItemBonus = "+3"}
If ($Item.BaseItem -like "*+4*") {$item.ItemBonus = "+4"}
If ($Item.BaseItem -like "*+5*") {$item.ItemBonus = "+5"}


#Make the base item nicer to read
If ($Item.BaseItem -like "*armor*") {$item.BaseItem = Get-DNDRandomArmorType}
If ($Item.BaseItem -like "*shield*") {$item.BaseItem = Get-DNDRandomShieldType}

Write-Host "`n`r============================================================="
Write-Host "Je item is: " -NoNewLine
Write-Host "$($Item.BaseItem) " -ForegroundColor Green -NoNewline
If ($Item.ItemBonus) {Write-Host "$($Item.ItemBonus) " -ForegroundColor Green -nonewline}
If ($Item.SpecialAbility) {Write-Host " met " -NoNewLine; Write-Host ($Item.SpecialAbility -join ", ") -ForegroundColor Green}

#endregion user feedback


#endregion main script

