Config = {}

-----------------------------------------------------------
-- debug
-----------------------------------------------------------
Config.Debug = false

-----------------------------------------------------------
-- npc settings
-----------------------------------------------------------
Config.DistanceSpawn = 20.0
Config.FadeIn = true

-----------------------------------------------------------
-- hunting wagon
-----------------------------------------------------------
Config.WagonPrice              = 1000     -- price set to buy a hunting wagon
Config.WagonSellRate           = 0.75    -- sell rate percentage for hunting wagon
Config.TotalAnimalsStored      = 10      -- total amount of animals you can store in the hunting cart
Config.WagonInventoryMaxWeight = 400000	 -- max inventory weight for the hunting wagon
Config.WagonInventorySlots     = 48      -- amount of inventory slots
Config.WagonFixRate            = 0.10    -- cost to fix the wagon when broken
Config.TargetDistance          = 5.0     -- distance you can target (prompt distance is defined in rsg-core/config.lua)

Config.Blip = {
    blipName   = 'Hunting Camp', -- Config.Blip.blipName
    blipSprite = 'blip_mp_attack_target', -- Config.Blip.blipSprite
    blipScale  = 0.2 -- Config.Blip.blipScale
}

-- prompt locations
Config.HunterLocations = {

    {
        name       = 'Hunting Camp',
        location   = 'huntercamp1',
        coords     = vector3(181.16, 340.88, 120.62),
        npcmodel   = `casp_hunting02_males_01`,
        npccoords  = vector4(181.16, 340.88, 120.62, 153.50),
        wagonspawn = vector4(177.21, 330.28, 119.86, 212.58),
        showblip   = true
    },
    {
        name       = 'Hunting Camp',
        location   = 'huntercamp2',
        coords     = vector3(2137.70, -631.67, 42.72),
        npcmodel   = `casp_hunting02_males_01`,
        npccoords  = vector4(2137.70, -631.67, 42.72, 320.75),
        wagonspawn = vector4(2140.12, -622.13, 41.58, 45.61),
        showblip   = true
    },
    
}

------------------------------
-- shop items
------------------------------
Config.HuntingShop = {
    [1]  = { name = 'weapon_melee_knife',             price = 5,    amount = 50,  info = {}, type = 'weapon', slot = 1, },
    [2]  = { name = 'weapon_bow',                     price = 5,    amount = 50,  info = {}, type = 'weapon', slot = 2, },
    [3]  = { name = 'weapon_lasso',                   price = 10,   amount = 50,  info = {}, type = 'weapon', slot = 3, },
    [4]  = { name = 'weapon_kit_binoculars',          price = 20,   amount = 50,  info = {}, type = 'weapon', slot = 4, },
    [5]  = { name = 'weapon_kit_binoculars_improved', price = 50,   amount = 50,  info = {}, type = 'weapon', slot = 5, },
    [6]  = { name = 'ammo_arrow',                     price = 0.25, amount = 500, info = {}, type = 'item',   slot = 6, },
}

-- animals table for name lookup
Config.Animals = {

    { modellabel = 'American Alligator',              modelname = 'a_c_alligator_01',            modelhash = -1892280447 },
    { modellabel = 'Legendary Bull Gator',            modelname = 'a_c_alligator_02',            modelhash = -1598866821 },
    { modellabel = 'Small American Alligator',        modelname = 'a_c_alligator_03',            modelhash = -1295720802 },
    { modellabel = 'Nine-Banded Armadillo',           modelname = 'a_c_armadillo_01',            modelhash = -1797625440 },
    { modellabel = 'American Badger',                 modelname = 'a_c_badger_01',               modelhash = -1170118274 },
    { modellabel = 'Little Brown Bat',                modelname = 'a_c_bat_01',                  modelhash = 674267496 },
    { modellabel = 'American Black Bear',             modelname = 'a_c_bearblack_01',            modelhash = 730092646 },
    { modellabel = 'Grizzly Bear',                    modelname = 'a_c_bear_01',                 modelhash = -1124266369 },
    { modellabel = 'North American Beaver',           modelname = 'a_c_beaver_01',               modelhash = 759906147 },
    { modellabel = 'Nevada Bighorn Sheep',            modelname = 'a_c_bighornram_01',           modelhash = -1568716381 },
    { modellabel = 'Blue Jay',                        modelname = 'a_c_bluejay_01',              modelhash = 1582986780 },
    { modellabel = 'Giant Boar',                      modelname = 'a_c_boarlegendary_01',        modelhash = -560342419 },
    { modellabel = 'Wild Boar',                       modelname = 'a_c_boar_01',                 modelhash = 2028722809 },
    { modellabel = 'Whitetail Buck',                  modelname = 'a_c_buck_01',                 modelhash = -1963605336 },
    { modellabel = 'American Bison',                  modelname = 'a_c_buffalo_01',              modelhash = 1556473961 },
    { modellabel = 'Legendary Tatanka Bison',         modelname = 'a_c_buffalo_tatanka_01',      modelhash = 367637652 },
    { modellabel = 'Angus Bull',                      modelname = 'a_c_bull_01',                 modelhash = 195700131 },
    { modellabel = 'Californian Condor',              modelname = 'a_c_californiacondor_01',     modelhash = 1205982615 },
    { modellabel = 'Northern Cardinal',               modelname = 'a_c_cardinal_01',             modelhash = 1784941179 },
    { modellabel = 'Carolina Parakeet',               modelname = 'a_c_carolinaparakeet_01',     modelhash = 1746830155 },
    { modellabel = 'American Domestic Cat',           modelname = 'a_c_cat_01',                  modelhash = 1462895032 },
    { modellabel = 'Cedar Waxwing',                   modelname = 'a_c_cedarwaxwing_01',         modelhash = -292997097 },
    { modellabel = 'Dominique Chicken',               modelname = 'a_c_chicken_01',              modelhash = -2063183075 },
    { modellabel = 'Western Chipmunk',                modelname = 'a_c_chipmunk_01',             modelhash = -1550768676 },
    { modellabel = 'Double-Crested Cormorant',        modelname = 'a_c_cormorant_01',            modelhash = -2073130256 },
    { modellabel = 'Cougar',                          modelname = 'a_c_cougar_01',               modelhash = 90264823 },
    { modellabel = 'Florida Cracker Cow',             modelname = 'a_c_cow',                     modelhash = -50684386 },
    { modellabel = 'California Valley Coyote',        modelname = 'a_c_coyote_01',               modelhash = 480688259 },
    { modellabel = 'Cuban Land Crab',                 modelname = 'a_c_crab_01',                 modelhash = -2037578922 },
    { modellabel = 'Whooping Crane',                  modelname = 'a_c_cranewhooping_01',        modelhash = -564099192 },
    { modellabel = 'Red Swamp Crayfish',              modelname = 'a_c_crawfish_01',             modelhash = -1763055991 },
    { modellabel = 'American Crow',                   modelname = 'a_c_crow_01',                 modelhash = 98537260 },
    { modellabel = 'Whitetail Deer',                  modelname = 'a_c_deer_01',                 modelhash = 1110710183 },
    { modellabel = 'American Foxhound',               modelname = 'a_c_dogamericanfoxhound_01',  modelhash = 1088428104 },
    { modellabel = 'Australian Shepherd',             modelname = 'a_c_dogaustraliansheperd_01', modelhash = -1368644756 },
    { modellabel = 'Bluetick Coonhound',              modelname = 'a_c_dogbluetickcoonhound_01', modelhash = 626176009 },
    { modellabel = 'Catahoula Cur',                   modelname = 'a_c_dogcatahoulacur_01',      modelhash = -1033903759 },
    { modellabel = 'Chesapeake Bay Retriever',        modelname = 'a_c_dogchesbayretriever_01',  modelhash = -389790005 },
    { modellabel = 'Border Collie',                   modelname = 'a_c_dogcollie_01',            modelhash = 1087552700 },
    { modellabel = 'Mangy Bluetick Coonhound',        modelname = 'a_c_doghobo_01',              modelhash = -976891307 },
    { modellabel = 'Bloodhound',                      modelname = 'a_c_doghound_01',             modelhash = -2146356753 },
    { modellabel = 'Siberian Husky',                  modelname = 'a_c_doghusky_01',             modelhash = 1660404147 },
    { modellabel = 'Labrador Retriever',              modelname = 'a_c_doglab_01',               modelhash = -1384669516 },
    { modellabel = 'King',                            modelname = 'a_c_doglion_01',              modelhash = -896926592 },
    { modellabel = 'Poodle',                          modelname = 'a_c_dogpoodle_01',            modelhash = 1087029479 },
    { modellabel = 'Rufus',                           modelname = 'a_c_dogrufus_01',             modelhash = 1591685812 },
    { modellabel = 'Mutt',                            modelname = 'a_c_dogstreet_01',            modelhash = 993083342 },
    { modellabel = 'Standard Donkey',                 modelname = 'a_c_donkey_01',               modelhash = 1772321403 },
    { modellabel = 'Mallard Duck',                    modelname = 'a_c_duck_01',                 modelhash = -1003616053 },
    { modellabel = 'Eagle',                           modelname = 'a_c_eagle_01',                modelhash = 1459778951 },
    { modellabel = 'Snowy Egret',                     modelname = 'a_c_egret_01',                modelhash = 831859211 },
    { modellabel = 'Rocky Mountain Cow Elk',          modelname = 'a_c_elk_01',                  modelhash = -2021043433 },
    { modellabel = 'Legendary Fox',                   modelname = 'a_c_fox_01',                  modelhash = 252669332},
    { modellabel = 'American Bullfrog',               modelname = 'a_c_frogbull_01',             modelhash = -930822792 },
    { modellabel = 'Banded Gila Monster',             modelname = 'a_c_gilamonster_01',          modelhash = 457416415 },
    { modellabel = 'Alpine Goat',                     modelname = 'a_c_goat_01',                 modelhash = -753902995 },
    { modellabel = 'Canada Goose',                    modelname = 'a_c_goosecanada_01',          modelhash = 723190474 },
    { modellabel = 'Ferruginous Hawk',                modelname = 'a_c_hawk_01',                 modelhash = -2145890973 },
    { modellabel = 'Great Blue Heron',                modelname = 'a_c_heron_01',                modelhash = 1095117488 },
    { modellabel = 'Desert Iguana',                   modelname = 'a_c_iguanadesert_01',         modelhash = -593056309 },
    { modellabel = 'Iguana',                          modelname = 'a_c_iguana_01',               modelhash = -1854059305 },
    { modellabel = 'Collared Peccary Pig',            modelname = 'a_c_javelina_01',             modelhash = 1751700893 },
    { modellabel = 'Lion',                            modelname = 'a_c_lionmangy_01',            modelhash = -963953562 },
    { modellabel = 'Common Loon',                     modelname = 'a_c_loon_01',                 modelhash = 386506078 },
    { modellabel = 'Western Moose',                   modelname = 'a_c_moose_01',                modelhash = -1098441944 },
    { modellabel = 'American Muskrat',                modelname = 'a_c_muskrat_01',              modelhash = -1134449699 },
    { modellabel = 'Baltimore Oriole',                modelname = 'a_c_oriole_01',               modelhash = -1302821723 },
    { modellabel = 'Great Horned Owl',                modelname = 'a_c_owl_01',                  modelhash = -861544272 },
    { modellabel = 'Angus Ox',                        modelname = 'a_c_ox_01',                   modelhash = 556355544 },
    { modellabel = 'Panther',                         modelname = 'a_c_panther_01',              modelhash = 1654513481 },
    { modellabel = 'Blue and Yellow Macaw',           modelname = 'a_c_parrot_01',               modelhash = -1797450568 },
    { modellabel = 'American White Pelican',          modelname = 'a_c_pelican_01',              modelhash = 1265966684},
    { modellabel = 'Ring-Necked Pheasant',            modelname = 'a_c_pheasant_01',             modelhash = 1416324601 },
    { modellabel = 'Rock Pigeon',                     modelname = 'a_c_pigeon',                  modelhash = 111281960 },
    { modellabel = 'Berkshire Pig',                   modelname = 'a_c_pig_01',                  modelhash = 1007418994 },
    { modellabel = 'Virginia Possum',                 modelname = 'a_c_possum_01',               modelhash = -1414989025 },
    { modellabel = 'Greater Prarie Chicken',          modelname = 'a_c_prairiechicken_01',       modelhash = 2079703102 },
    { modellabel = 'American Pronghorn Doe',          modelname = 'a_c_pronghorn_01',            modelhash = 1755643085 },
    { modellabel = 'California Quail',                modelname = 'a_c_quail_01',                modelhash = 2105463796 },
    { modellabel = 'Black-Tailed Jackrabbit',         modelname = 'a_c_rabbit_01',               modelhash = -541762431 },
    { modellabel = 'North American Raccoon',          modelname = 'a_c_raccoon_01',              modelhash = 1458540991 },
    { modellabel = 'Brown Rat',                       modelname = 'a_c_rat_01',                  modelhash = 989669666 },
    { modellabel = 'Western Raven',                   modelname = 'a_c_raven_01',                modelhash = -575340245 },
    { modellabel = 'Red-Footed Booby',                modelname = 'a_c_redfootedbooby_01',       modelhash = -466687768 },
    { modellabel = 'American Robin',                  modelname = 'a_c_robin_01',                modelhash = -1210546580 },
    { modellabel = 'Dominique Rooster',               modelname = 'a_c_rooster_01',              modelhash = 2023522846 },
    { modellabel = 'Roseate Spoonbill',               modelname = 'a_c_roseatespoonbill_01',     modelhash = -1076508705 },
    { modellabel = 'Herring Gull',                    modelname = 'a_c_seagull_01',              modelhash = -164963696},
    { modellabel = 'Hammerhead Shark',                modelname = 'a_c_sharkhammerhead_01',      modelhash = -840801889 },
    { modellabel = 'Tiger Shark',                     modelname = 'a_c_sharktiger',              modelhash = 113504370 },
    { modellabel = 'Merino Sheep',                    modelname = 'a_c_sheep_01',                modelhash = 40345436 },
    { modellabel = 'Striped Skunk',                   modelname = 'a_c_skunk_01',                modelhash = -1211566332 },
    { modellabel = 'Black-Tailed Rattlesnake',        modelname = 'a_c_snakeblacktailrattle_01', modelhash = 846659001 },
    { modellabel = 'Fer-de-Lance Snake',              modelname = 'a_c_snakeferdelance_01',      modelhash = 1464167925 },
    { modellabel = 'Red-Tailed Boa',                  modelname = 'a_c_snakeredboa10ft_01',      modelhash = -1747620994 },
    { modellabel = 'Red-Tailed Boa',                  modelname = 'a_c_snakeredboa_01',          modelhash = -1790499186 },
    { modellabel = 'Midland Water Snake',             modelname = 'a_c_snakewater_01',           modelhash = -229688157 },
    { modellabel = 'Western Diamondback Rattlesnake', modelname = 'a_c_snake_01',                modelhash = 545068538 },
    { modellabel = 'Western Tanager Songbird',        modelname = 'a_c_songbird_01',             modelhash = -1910795227 },
    { modellabel = 'American Tree Sparrow',           modelname = 'a_c_sparrow_01',              modelhash = -1028170431 },
    { modellabel = 'Western Red Squirrel',            modelname = 'a_c_squirrel_01',             modelhash = 1465438313 },
    { modellabel = 'Western Toad',                    modelname = 'a_c_toad_01',                 modelhash = 1502581273 },
    { modellabel = 'Eastern Wild Turkey',             modelname = 'a_c_turkeywild_01',           modelhash = -2011226991 },
    { modellabel = 'Eastern Wild Turkey',             modelname = 'a_c_turkey_01',               modelhash = -466054788 },
    { modellabel = 'Eastern Wild Turkey',             modelname = 'a_c_turkey_02',               modelhash = -166054593 },
    { modellabel = 'Sea Turtle',                      modelname = 'a_c_turtlesea_01',            modelhash = -1451393780 },
    { modellabel = 'Snapping Turtle',                 modelname = 'a_c_turtlesnapping_01',       modelhash = -407730502 },
    { modellabel = 'Western Turkey Vulture',          modelname = 'a_c_vulture_01',              modelhash = 1104697660 },
    { modellabel = 'Gray Wolf',                       modelname = 'a_c_wolf',                    modelhash = -1143398950 },
    { modellabel = 'Gray Wolf',                       modelname = 'a_c_wolf_medium',             modelhash = -885451903 },
    { modellabel = 'Gray Wolf',                       modelname = 'a_c_wolf_small',              modelhash = -829273561 },
    { modellabel = 'Red-Bellied Woodpecker',          modelname = 'a_c_woodpecker_01',           modelhash = 510312109 },
    { modellabel = 'Pileated Woodpecker',             modelname = 'a_c_woodpecker_02',           modelhash = 729471181 },

}
