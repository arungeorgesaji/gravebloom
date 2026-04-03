local biomes = {
    grave = {
        name = "Grave",
        skyGradient = {
            top = {0.08, 0.05, 0.12},
            bottom = {0.12, 0.08, 0.18}
        },
        groundColor = {0.20, 0.12, 0.18},
        groundVariation = 0.05,
        cloudColor = {0.5, 0.4, 0.6},
        cloudAlpha = 0.4,
        sporeColor = {0.7, 0.4, 0.8},
        birdColor = {0.3, 0.2, 0.4},
        dustColor = {0.6, 0.5, 0.7},
        groundY = 15,
        cloudYRange = {50, 300},
        sporeCount = {30, 50},
        birdCount = {3, 8},
        dustCount = {50, 80},
        
        atmosphere = {
            fogDensity = 0.3,
            fogColor = {0.15, 0.10, 0.20},
            windStrength = 0.5,
            ambientLight = {0.2, 0.15, 0.25},
            particleDensity = 0.4
        },
        
        terrain = {
            heightVariation = 2,
            caveDensity = 0.1,
            oreRarity = {
                stone = 0.7,
                iron = 0.2,
                gold = 0.05,
                crystal = 0.05
            },
            treeDensity = 0.05,
            grassDensity = 0.1
        },
        
        weather = {
            type = "fog",
            intensity = 0.6,
            frequency = 0.3,
            temperature = 45,
            humidity = 0.7
        },
        
        entities = {
            mobSpawnRate = 0.02,
            passiveMobs = {"ghost", "wisp"},
            hostileMobs = {"skeleton", "zombie"},
            plantLife = {"mushroom", "crypt_flower"}
        },
        
        effects = {
            screenShake = 0.1,
            musicTrack = "grave_ambient",
            ambientSound = "wind_howl",
            particleEffect = "dust_motes"
        },
        
        transitions = {
            allowedNeighbors = {"decay", "ash"},
            transitionWidth = 5,
            blendMode = "smooth"
        }
    },
    
    forest = {
        name = "Forest",
        skyGradient = {
            top = {0.05, 0.08, 0.12},
            bottom = {0.10, 0.15, 0.20}
        },
        groundColor = {0.15, 0.25, 0.12},
        groundVariation = 0.08,
        cloudColor = {0.6, 0.7, 0.7},
        cloudAlpha = 0.5,
        sporeColor = {0.5, 0.8, 0.4},
        birdColor = {0.2, 0.3, 0.2},
        dustColor = {0.5, 0.6, 0.4},
        groundY = 15,
        cloudYRange = {80, 350},
        sporeCount = {40, 70},
        birdCount = {5, 12},
        dustCount = {60, 100},
        
        atmosphere = {
            fogDensity = 0.15,
            fogColor = {0.1, 0.2, 0.1},
            windStrength = 0.8,
            ambientLight = {0.3, 0.4, 0.2},
            particleDensity = 0.6
        },
        
        terrain = {
            heightVariation = 4,
            caveDensity = 0.05,
            oreRarity = {
                stone = 0.5,
                iron = 0.3,
                gold = 0.15,
                crystal = 0.05
            },
            treeDensity = 0.4,
            grassDensity = 0.7
        },
        
        weather = {
            type = "rain",
            intensity = 0.3,
            frequency = 0.5,
            temperature = 65,
            humidity = 0.8
        },
        
        entities = {
            mobSpawnRate = 0.03,
            passiveMobs = {"deer", "rabbit", "bird"},
            hostileMobs = {"wolf", "bear"},
            plantLife = {"oak", "birch", "fern"}
        },
        
        effects = {
            screenShake = 0.05,
            musicTrack = "forest_peaceful",
            ambientSound = "birds_chirping",
            particleEffect = "leaf_fall"
        },
        
        transitions = {
            allowedNeighbors = {"bloom", "sunset"},
            transitionWidth = 8,
            blendMode = "smooth"
        }
    },
    
    crystal = {
        name = "Crystal",
        skyGradient = {
            top = {0.05, 0.03, 0.15},
            bottom = {0.10, 0.08, 0.25}
        },
        groundColor = {0.12, 0.10, 0.25},
        groundVariation = 0.10,
        cloudColor = {0.5, 0.4, 0.8},
        cloudAlpha = 0.6,
        sporeColor = {0.4, 0.3, 0.9},
        birdColor = {0.3, 0.2, 0.6},
        dustColor = {0.5, 0.4, 0.8},
        groundY = 15,
        cloudYRange = {40, 280},
        sporeCount = {50, 80},
        birdCount = {2, 5},
        dustCount = {70, 120},
        
        atmosphere = {
            fogDensity = 0.2,
            fogColor = {0.12, 0.10, 0.25},
            windStrength = 0.3,
            ambientLight = {0.25, 0.20, 0.35},
            particleDensity = 0.7
        },
        
        terrain = {
            heightVariation = 3,
            caveDensity = 0.15,
            oreRarity = {
                stone = 0.3,
                iron = 0.2,
                gold = 0.2,
                crystal = 0.3
            },
            treeDensity = 0.02,
            grassDensity = 0.05
        },
        
        weather = {
            type = "clear",
            intensity = 0.1,
            frequency = 0.2,
            temperature = 50,
            humidity = 0.3
        },
        
        entities = {
            mobSpawnRate = 0.01,
            passiveMobs = {"crystal_butterfly", "shardling"},
            hostileMobs = {"crystal_golem", "shard_spider"},
            plantLife = {"crystal_shard", "glow_moss"}
        },
        
        effects = {
            screenShake = 0.08,
            musicTrack = "crystal_caverns",
            ambientSound = "crystal_hum",
            particleEffect = "sparkle"
        },
        
        transitions = {
            allowedNeighbors = {"dream", "void"},
            transitionWidth = 6,
            blendMode = "smooth"
        }
    },
    
    ash = {
        name = "Ash",
        skyGradient = {
            top = {0.10, 0.08, 0.10},
            bottom = {0.15, 0.12, 0.15}
        },
        groundColor = {0.25, 0.20, 0.22},
        groundVariation = 0.03,
        cloudColor = {0.4, 0.4, 0.4},
        cloudAlpha = 0.3,
        sporeColor = {0.6, 0.5, 0.5},
        birdColor = {0.2, 0.2, 0.2},
        dustColor = {0.5, 0.5, 0.5},
        groundY = 15,
        cloudYRange = {60, 320},
        sporeCount = {20, 40},
        birdCount = {1, 3},
        dustCount = {40, 60},
        
        atmosphere = {
            fogDensity = 0.45,
            fogColor = {0.20, 0.18, 0.20},
            windStrength = 0.6,
            ambientLight = {0.15, 0.12, 0.15},
            particleDensity = 0.5
        },
        
        terrain = {
            heightVariation = 1,
            caveDensity = 0.08,
            oreRarity = {
                stone = 0.6,
                iron = 0.25,
                gold = 0.1,
                crystal = 0.05
            },
            treeDensity = 0.0,
            grassDensity = 0.0
        },
        
        weather = {
            type = "ashfall",
            intensity = 0.7,
            frequency = 0.4,
            temperature = 80,
            humidity = 0.1
        },
        
        entities = {
            mobSpawnRate = 0.015,
            passiveMobs = {"ash_lizard"},
            hostileMobs = {"fire_spirit", "magma_crawler"},
            plantLife = {"ash_bush", "cinder_weed"}
        },
        
        effects = {
            screenShake = 0.12,
            musicTrack = "ash_wastes",
            ambientSound = "crackling_fire",
            particleEffect = "ash_flake"
        },
        
        transitions = {
            allowedNeighbors = {"grave", "decay"},
            transitionWidth = 4,
            blendMode = "smooth"
        }
    },
    
    dream = {
        name = "Dream",
        skyGradient = {
            top = {0.15, 0.05, 0.20},
            bottom = {0.25, 0.10, 0.30}
        },
        groundColor = {0.18, 0.08, 0.25},
        groundVariation = 0.12,
        cloudColor = {0.7, 0.5, 0.9},
        cloudAlpha = 0.5,
        sporeColor = {0.9, 0.6, 1.0},
        birdColor = {0.5, 0.3, 0.7},
        dustColor = {0.8, 0.5, 0.9},
        groundY = 15,
        cloudYRange = {30, 250},
        sporeCount = {60, 90},
        birdCount = {4, 10},
        dustCount = {80, 130},
        
        atmosphere = {
            fogDensity = 0.25,
            fogColor = {0.20, 0.12, 0.28},
            windStrength = 0.4,
            ambientLight = {0.35, 0.20, 0.45},
            particleDensity = 0.8
        },
        
        terrain = {
            heightVariation = 5,
            caveDensity = 0.12,
            oreRarity = {
                stone = 0.4,
                iron = 0.2,
                gold = 0.2,
                crystal = 0.2
            },
            treeDensity = 0.15,
            grassDensity = 0.3
        },
        
        weather = {
            type = "mist",
            intensity = 0.5,
            frequency = 0.6,
            temperature = 55,
            humidity = 0.9
        },
        
        entities = {
            mobSpawnRate = 0.025,
            passiveMobs = {"dream_cat", "mothling"},
            hostileMobs = {"nightmare", "dream_eater"},
            plantLife = {"dream_lily", "moon_flower"}
        },
        
        effects = {
            screenShake = 0.03,
            musicTrack = "dream_realm",
            ambientSound = "ethereal_hum",
            particleEffect = "dream_dust"
        },
        
        transitions = {
            allowedNeighbors = {"bloom", "crystal"},
            transitionWidth = 7,
            blendMode = "smooth"
        }
    },
    
    decay = {
        name = "Decay",
        skyGradient = {
            top = {0.06, 0.04, 0.05},
            bottom = {0.10, 0.06, 0.08}
        },
        groundColor = {0.12, 0.08, 0.10},
        groundVariation = 0.04,
        cloudColor = {0.3, 0.2, 0.25},
        cloudAlpha = 0.35,
        sporeColor = {0.4, 0.3, 0.2},
        birdColor = {0.15, 0.10, 0.12},
        dustColor = {0.3, 0.2, 0.25},
        groundY = 15,
        cloudYRange = {70, 280},
        sporeCount = {25, 45},
        birdCount = {2, 5},
        dustCount = {45, 70},
        
        atmosphere = {
            fogDensity = 0.35,
            fogColor = {0.10, 0.08, 0.12},
            windStrength = 0.45,
            ambientLight = {0.12, 0.10, 0.15},
            particleDensity = 0.45
        },
        
        terrain = {
            heightVariation = 2,
            caveDensity = 0.2,
            oreRarity = {
                stone = 0.8,
                iron = 0.15,
                gold = 0.04,
                crystal = 0.01
            },
            treeDensity = 0.03,
            grassDensity = 0.08
        },
        
        weather = {
            type = "smog",
            intensity = 0.65,
            frequency = 0.35,
            temperature = 40,
            humidity = 0.85
        },
        
        entities = {
            mobSpawnRate = 0.018,
            passiveMobs = {"rot_worm"},
            hostileMobs = {"decayed_zombie", "plague_rat"},
            plantLife = {"blight_mushroom", "rot_flower"}
        },
        
        effects = {
            screenShake = 0.09,
            musicTrack = "decay_ruins",
            ambientSound = "dripping_water",
            particleEffect = "decay_spores"
        },
        
        transitions = {
            allowedNeighbors = {"grave", "ash", "miasma"},
            transitionWidth = 6,
            blendMode = "smooth"
        }
    },
    
    bloom = {
        name = "Bloom",
        skyGradient = {
            top = {0.20, 0.10, 0.15},
            bottom = {0.35, 0.15, 0.25}
        },
        groundColor = {0.25, 0.12, 0.20},
        groundVariation = 0.09,
        cloudColor = {0.8, 0.5, 0.7},
        cloudAlpha = 0.55,
        sporeColor = {1.0, 0.4, 0.8},
        birdColor = {0.6, 0.3, 0.5},
        dustColor = {0.9, 0.5, 0.7},
        groundY = 15,
        cloudYRange = {45, 260},
        sporeCount = {55, 85},
        birdCount = {6, 14},
        dustCount = {90, 140},
        
        atmosphere = {
            fogDensity = 0.18,
            fogColor = {0.28, 0.15, 0.22},
            windStrength = 0.7,
            ambientLight = {0.45, 0.25, 0.35},
            particleDensity = 0.75
        },
        
        terrain = {
            heightVariation = 3,
            caveDensity = 0.03,
            oreRarity = {
                stone = 0.4,
                iron = 0.25,
                gold = 0.2,
                crystal = 0.15
            },
            treeDensity = 0.35,
            grassDensity = 0.85
        },
        
        weather = {
            type = "pollen",
            intensity = 0.4,
            frequency = 0.55,
            temperature = 70,
            humidity = 0.75
        },
        
        entities = {
            mobSpawnRate = 0.035,
            passiveMobs = {"butterfly", "fairy", "bloom_sprite"},
            hostileMobs = {"thorn_vine", "poison_flower"},
            plantLife = {"rose", "tulip", "bloom_tree"}
        },
        
        effects = {
            screenShake = 0.04,
            musicTrack = "bloom_garden",
            ambientSound = "birds_singing",
            particleEffect = "flower_petal"
        },
        
        transitions = {
            allowedNeighbors = {"forest", "dream", "sunset"},
            transitionWidth = 7,
            blendMode = "smooth"
        }
    },
    
    abyss = {
        name = "Abyss",
        skyGradient = {
            top = {0.02, 0.01, 0.03},
            bottom = {0.04, 0.02, 0.06}
        },
        groundColor = {0.06, 0.04, 0.10},
        groundVariation = 0.02,
        cloudColor = {0.15, 0.10, 0.20},
        cloudAlpha = 0.25,
        sporeColor = {0.3, 0.2, 0.5},
        birdColor = {0.08, 0.05, 0.12},
        dustColor = {0.2, 0.15, 0.25},
        groundY = 15,
        cloudYRange = {90, 300},
        sporeCount = {15, 30},
        birdCount = {1, 4},
        dustCount = {30, 50},
        
        atmosphere = {
            fogDensity = 0.55,
            fogColor = {0.05, 0.03, 0.08},
            windStrength = 0.2,
            ambientLight = {0.08, 0.05, 0.12},
            particleDensity = 0.3
        },
        
        terrain = {
            heightVariation = 1,
            caveDensity = 0.25,
            oreRarity = {
                stone = 0.85,
                iron = 0.1,
                gold = 0.03,
                crystal = 0.02
            },
            treeDensity = 0.0,
            grassDensity = 0.0
        },
        
        weather = {
            type = "darkness",
            intensity = 0.85,
            frequency = 0.25,
            temperature = 35,
            humidity = 0.95
        },
        
        entities = {
            mobSpawnRate = 0.012,
            passiveMobs = {"deep_fish", "abyss_worm"},
            hostileMobs = {"shadow_beast", "void_spawn"},
            plantLife = {"abyss_coral", "dark_kelp"}
        },
        
        effects = {
            screenShake = 0.15,
            musicTrack = "abyss_depths",
            ambientSound = "deep_pressure",
            particleEffect = "dark_mist"
        },
        
        transitions = {
            allowedNeighbors = {"void", "crystal"},
            transitionWidth = 8,
            blendMode = "smooth"
        }
    },
    
    sunset = {
        name = "Sunset",
        skyGradient = {
            top = {0.15, 0.05, 0.08},
            bottom = {0.35, 0.12, 0.10}
        },
        groundColor = {0.22, 0.10, 0.12},
        groundVariation = 0.07,
        cloudColor = {0.8, 0.4, 0.5},
        cloudAlpha = 0.45,
        sporeColor = {0.9, 0.5, 0.4},
        birdColor = {0.5, 0.25, 0.30},
        dustColor = {0.7, 0.4, 0.45},
        groundY = 15,
        cloudYRange = {60, 290},
        sporeCount = {35, 55},
        birdCount = {4, 9},
        dustCount = {55, 85},
        
        atmosphere = {
            fogDensity = 0.12,
            fogColor = {0.30, 0.12, 0.15},
            windStrength = 0.65,
            ambientLight = {0.40, 0.20, 0.22},
            particleDensity = 0.55
        },
        
        terrain = {
            heightVariation = 3,
            caveDensity = 0.04,
            oreRarity = {
                stone = 0.55,
                iron = 0.3,
                gold = 0.1,
                crystal = 0.05
            },
            treeDensity = 0.25,
            grassDensity = 0.5
        },
        
        weather = {
            type = "warm_breeze",
            intensity = 0.25,
            frequency = 0.45,
            temperature = 75,
            humidity = 0.5
        },
        
        entities = {
            mobSpawnRate = 0.028,
            passiveMobs = {"firefly", "evening_bird"},
            hostileMobs = {"dusk_wolf", "twilight_bat"},
            plantLife = {"sunset_fern", "dusk_bloom"}
        },
        
        effects = {
            screenShake = 0.06,
            musicTrack = "sunset_serenade",
            ambientSound = "evening_crickets",
            particleEffect = "warm_spark"
        },
        
        transitions = {
            allowedNeighbors = {"forest", "bloom", "frost"},
            transitionWidth = 7,
            blendMode = "smooth"
        }
    },
    
    frost = {
        name = "Frost",
        skyGradient = {
            top = {0.06, 0.10, 0.15},
            bottom = {0.10, 0.15, 0.22}
        },
        groundColor = {0.12, 0.18, 0.22},
        groundVariation = 0.06,
        cloudColor = {0.5, 0.6, 0.7},
        cloudAlpha = 0.5,
        sporeColor = {0.4, 0.7, 0.9},
        birdColor = {0.25, 0.35, 0.45},
        dustColor = {0.5, 0.6, 0.8},
        groundY = 15,
        cloudYRange = {70, 310},
        sporeCount = {35, 60},
        birdCount = {3, 7},
        dustCount = {50, 75},
        
        atmosphere = {
            fogDensity = 0.28,
            fogColor = {0.12, 0.18, 0.25},
            windStrength = 0.75,
            ambientLight = {0.20, 0.30, 0.35},
            particleDensity = 0.5
        },
        
        terrain = {
            heightVariation = 4,
            caveDensity = 0.06,
            oreRarity = {
                stone = 0.6,
                iron = 0.25,
                gold = 0.1,
                crystal = 0.05
            },
            treeDensity = 0.2,
            grassDensity = 0.15
        },
        
        weather = {
            type = "snow",
            intensity = 0.5,
            frequency = 0.4,
            temperature = 20,
            humidity = 0.6
        },
        
        entities = {
            mobSpawnRate = 0.022,
            passiveMobs = {"snow_rabbit", "ice_fox"},
            hostileMobs = {"frost_wolf", "ice_elemental"},
            plantLife = {"frost_fern", "snow_berry"}
        },
        
        effects = {
            screenShake = 0.07,
            musicTrack = "frozen_peaks",
            ambientSound = "howling_wind",
            particleEffect = "snowflake"
        },
        
        transitions = {
            allowedNeighbors = {"sunset", "miasma"},
            transitionWidth = 6,
            blendMode = "smooth"
        }
    },
    
    miasma = {
        name = "Miasma",
        skyGradient = {
            top = {0.04, 0.06, 0.03},
            bottom = {0.08, 0.12, 0.05}
        },
        groundColor = {0.10, 0.15, 0.08},
        groundVariation = 0.07,
        cloudColor = {0.4, 0.5, 0.3},
        cloudAlpha = 0.4,
        sporeColor = {0.5, 0.8, 0.3},
        birdColor = {0.20, 0.30, 0.15},
        dustColor = {0.4, 0.6, 0.3},
        groundY = 15,
        cloudYRange = {55, 270},
        sporeCount = {45, 75},
        birdCount = {2, 6},
        dustCount = {65, 95},
        
        atmosphere = {
            fogDensity = 0.5,
            fogColor = {0.12, 0.18, 0.08},
            windStrength = 0.35,
            ambientLight = {0.15, 0.22, 0.12},
            particleDensity = 0.65
        },
        
        terrain = {
            heightVariation = 2,
            caveDensity = 0.18,
            oreRarity = {
                stone = 0.65,
                iron = 0.2,
                gold = 0.1,
                crystal = 0.05
            },
            treeDensity = 0.08,
            grassDensity = 0.2
        },
        
        weather = {
            type = "toxic_gas",
            intensity = 0.7,
            frequency = 0.35,
            temperature = 60,
            humidity = 0.9
        },
        
        entities = {
            mobSpawnRate = 0.02,
            passiveMobs = {"slime", "fungus_beetle"},
            hostileMobs = {"toxic_spitter", "miasma_wraith"},
            plantLife = {"poison_mushroom", "corpse_flower"}
        },
        
        effects = {
            screenShake = 0.11,
            musicTrack = "miasma_swamp",
            ambientSound = "bubbling_ooze",
            particleEffect = "poison_gas"
        },
        
        transitions = {
            allowedNeighbors = {"decay", "frost"},
            transitionWidth = 5,
            blendMode = "smooth"
        }
    },
    
    void = {
        name = "Void",
        skyGradient = {
            top = {0.01, 0.01, 0.02},
            bottom = {0.02, 0.01, 0.03}
        },
        groundColor = {0.03, 0.02, 0.05},
        groundVariation = 0.01,
        cloudColor = {0.08, 0.05, 0.10},
        cloudAlpha = 0.2,
        sporeColor = {0.15, 0.10, 0.25},
        birdColor = {0.04, 0.03, 0.06},
        dustColor = {0.10, 0.08, 0.15},
        groundY = 15,
        cloudYRange = {100, 350},
        sporeCount = {10, 20},
        birdCount = {0, 2},
        dustCount = {20, 35},
        
        atmosphere = {
            fogDensity = 0.7,
            fogColor = {0.02, 0.01, 0.04},
            windStrength = 0.1,
            ambientLight = {0.03, 0.02, 0.06},
            particleDensity = 0.2
        },
        
        terrain = {
            heightVariation = 0,
            caveDensity = 0.3,
            oreRarity = {
                stone = 0.9,
                iron = 0.07,
                gold = 0.02,
                crystal = 0.01
            },
            treeDensity = 0.0,
            grassDensity = 0.0
        },
        
        weather = {
            type = "void_storm",
            intensity = 0.9,
            frequency = 0.15,
            temperature = -10,
            humidity = 0.0
        },
        
        entities = {
            mobSpawnRate = 0.008,
            passiveMobs = {"void_whisper"},
            hostileMobs = {"void_beast", "abomination"},
            plantLife = {}
        },
        
        effects = {
            screenShake = 0.2,
            musicTrack = "void_eternal",
            ambientSound = "silence",
            particleEffect = "void_energy"
        },
        
        transitions = {
            allowedNeighbors = {"abyss", "crystal"},
            transitionWidth = 10,
            blendMode = "smooth"
        }
    }
}

return biomes
