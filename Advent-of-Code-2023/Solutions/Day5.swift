//
//  Day5.swift
//  Advent-of-Code-2023
//
//  Created by Daniel Paten on 15/12/2023.
//

import Foundation

class Day5 {
    static func partOne() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 5)
            
            // Dictionary initialisation to store all the mappings
            var seeds = [String]()
            var seedToSoil: [ClosedRange<Int> : Int] = [:]
            var soilToFertiliser: [ClosedRange<Int> : Int] = [:]
            var fertiliserToWater: [ClosedRange<Int> : Int] = [:]
            var waterToLight: [ClosedRange<Int> : Int] = [:]
            var lightToTemp: [ClosedRange<Int> : Int] = [:]
            var tempToHumidity: [ClosedRange<Int> : Int] = [:]
            var humidityToLocation: [ClosedRange<Int> : Int] = [:]
            var locations = [Int]()
            var status = 0
            
            for line in lines {
                guard !line.isEmpty else { continue }
                
                // trigger for maps
                if line.hasPrefix("seed-") {
                    status = 1
                    continue
                } else if line.hasPrefix("soil") {
                    status = 2
                    continue
                } else if line.hasPrefix("fertilizer") {
                    status = 3
                    continue
                } else if line.hasPrefix("water") {
                    status = 4
                    continue
                } else if line.hasPrefix("light") {
                    status = 5
                    continue
                } else if line.hasPrefix("temperature") {
                    status = 6
                    continue
                } else if line.hasPrefix("humidity") {
                    status = 7
                    continue
                } else if line.hasPrefix("location") {
                    status = 8
                    continue
                }
                
                // build out the range dictionaries
                switch status {
                case 0:
                    seeds = line.components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
                case 1:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let seedRange = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                    let soilMin = Int(mapLine[0])!
                    seedToSoil[seedRange] = soilMin
                case 2:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let soilRange = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                    let fertiliserMin = Int(mapLine[0])!
                    soilToFertiliser[soilRange] = fertiliserMin
                case 3:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let fertiliserRange = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                    let waterMin = Int(mapLine[0])!
                    fertiliserToWater[fertiliserRange] = waterMin
                case 4:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let waterRange = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                    let lightMin = Int(mapLine[0])!
                    waterToLight[waterRange] = lightMin
                case 5:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let lightRange = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                    let tempMin = Int(mapLine[0])!
                    lightToTemp[lightRange] = tempMin
                case 6:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let tempRange = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                    let humidityMin = Int(mapLine[0])!
                    tempToHumidity[tempRange] = humidityMin
                case 7:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let humidityRange = Int(mapLine[1])!...(Int(mapLine[1])!+Int(mapLine[2])!-1)
                    let locationMin = Int(mapLine[0])!
                    humidityToLocation[humidityRange] = locationMin
                default:
                    throw Day5Error.invalidStatus(status: status)
                }
            }
            
            // search each seed
            for seed in seeds {
                let seedNum = Int(seed)!
                
                // seed to soil
                var soilNum = seedNum
                for (key, value) in seedToSoil {
                    let search = key.contains(seedNum)
                    if (search) {
                        soilNum = value + (seedNum-key.lowerBound)
                        break
                    }
                }
                
                // soil to fertiliser
                var fertiliserNum = soilNum
                for (key, value) in soilToFertiliser {
                    let search = key.contains(soilNum)
                    if (search) {
                        fertiliserNum = value + (soilNum-key.lowerBound)
                        break
                    }
                }
                
                // fertiliser to water
                var waterNum = fertiliserNum
                for (key, value) in fertiliserToWater {
                    let search = key.contains(fertiliserNum)
                    if (search) {
                        waterNum = value + (fertiliserNum-key.lowerBound)
                        break
                    }
                }
                
                // water to light
                var lightNum = waterNum
                for (key, value) in waterToLight {
                    let search = key.contains(waterNum)
                    if (search) {
                        lightNum = value + (waterNum-key.lowerBound)
                        break
                    }
                }
                
                // light to temperature
                var tempNum = lightNum
                for (key, value) in lightToTemp {
                    let search = key.contains(lightNum)
                    if (search) {
                        tempNum = value + (lightNum-key.lowerBound)
                        break
                    }
                }
                
                // temperature to humidity
                var humidityNum = tempNum
                for (key, value) in tempToHumidity {
                    let search = key.contains(tempNum)
                    if (search) {
                        humidityNum = value + (tempNum-key.lowerBound)
                        break
                    }
                }
                
                // humidity to location
                var locationNum = humidityNum
                for (key, value) in humidityToLocation {
                    let search = key.contains(humidityNum)
                    if (search) {
                        locationNum = value + (humidityNum-key.lowerBound)
                        break
                    }
                }
                locations.append(locationNum)
            }
            print(locations.min()!)
        } catch {
            print(error)
        }
    }
    
    static func partTwo() {
        do {
            // get the data from the input file
            let lines = try InputReader.readFile(day: 5)
            
            // Dictionary initialisation to store all the mappings
            var seeds = [ClosedRange<Int>]()
            var soilToSeed: [ClosedRange<Int> : Int] = [:]
            var fertiliserToSoil: [ClosedRange<Int> : Int] = [:]
            var waterToFertiliser: [ClosedRange<Int> : Int] = [:]
            var lightToWater: [ClosedRange<Int> : Int] = [:]
            var tempToLight: [ClosedRange<Int> : Int] = [:]
            var humidityToTemp: [ClosedRange<Int> : Int] = [:]
            var locationToHumidity: [ClosedRange<Int> : Int] = [:]
            var status = 0
            
            for line in lines {
                guard !line.isEmpty else { continue }
                
                // trigger for maps
                if line.hasPrefix("seed-") {
                    status = 1
                    continue
                } else if line.hasPrefix("soil") {
                    status = 2
                    continue
                } else if line.hasPrefix("fertilizer") {
                    status = 3
                    continue
                } else if line.hasPrefix("water") {
                    status = 4
                    continue
                } else if line.hasPrefix("light") {
                    status = 5
                    continue
                } else if line.hasPrefix("temperature") {
                    status = 6
                    continue
                } else if line.hasPrefix("humidity") {
                    status = 7
                    continue
                } else if line.hasPrefix("location") {
                    status = 8
                    continue
                }
                
                // build out the range dictionaries
                switch status {
                case 0:
                    let seedLine = line.components(separatedBy: .decimalDigits.inverted).filter{!$0.isEmpty}
                    for i in 0..<seedLine.count where (i % 2 == 0) {
                        seeds.append(Int(seedLine[i])!...(Int(seedLine[i])!+Int(seedLine[i+1])!-1))
                    }
                case 1:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let soilRange = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                    let seedMin = Int(mapLine[1])!
                    soilToSeed[soilRange] = seedMin
                case 2:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let fertiliserRange = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                    let soilMin = Int(mapLine[1])!
                    fertiliserToSoil[fertiliserRange] = soilMin
                case 3:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let waterRange = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                    let fertiliserMin = Int(mapLine[1])!
                    waterToFertiliser[waterRange] = fertiliserMin
                case 4:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let lightRange = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                    let waterMin = Int(mapLine[1])!
                    lightToWater[lightRange] = waterMin
                case 5:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let tempRange = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                    let lightMin = Int(mapLine[1])!
                    tempToLight[tempRange] = lightMin
                case 6:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let humidityRange = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                    let tempMin = Int(mapLine[1])!
                    humidityToTemp[humidityRange] = tempMin
                case 7:
                    let mapLine = line.components(separatedBy: .decimalDigits.inverted)
                    let locationRange = Int(mapLine[0])!...(Int(mapLine[0])!+Int(mapLine[2])!-1)
                    let humidityMin = Int(mapLine[1])!
                    locationToHumidity[locationRange] = humidityMin
                default:
                    throw Day5Error.invalidStatus(status: status)
                }
            }
            
            // iterate by location and check if seed exists
            var locationNum = 0
            
            while true {
                // location to humidity
                var humidityNum = locationNum
                for (key, value) in locationToHumidity {
                    let search = key.contains(locationNum)
                    if (search) {
                        humidityNum = value + (locationNum-key.lowerBound)
                        break
                    }
                }
                
                // humidity to temperature
                var tempNum = humidityNum
                for (key, value) in humidityToTemp {
                    let search = key.contains(humidityNum)
                    if (search) {
                        tempNum = value + (humidityNum-key.lowerBound)
                        break
                    }
                }
                
                // temperature to light
                var lightNum = tempNum
                for (key, value) in tempToLight {
                    let search = key.contains(tempNum)
                    if (search) {
                        lightNum = value + (tempNum-key.lowerBound)
                        break
                    }
                }
                
                // light to water
                var waterNum = lightNum
                for (key, value) in lightToWater {
                    let search = key.contains(lightNum)
                    if (search) {
                        waterNum = value + (lightNum-key.lowerBound)
                        break
                    }
                }
                
                // water to fertiliser
                var fertiliserNum = waterNum
                for (key, value) in waterToFertiliser {
                    let search = key.contains(waterNum)
                    if (search) {
                        fertiliserNum = value + (waterNum-key.lowerBound)
                        break
                    }
                }
                
                // fertiliser to soil
                var soilNum = fertiliserNum
                for (key, value) in fertiliserToSoil {
                    let search = key.contains(fertiliserNum)
                    if (search) {
                        soilNum = value + (fertiliserNum-key.lowerBound)
                        break
                    }
                }
                
                // seed to soil
                var seedNum = soilNum
                for (key, value) in soilToSeed {
                    let search = key.contains(soilNum)
                    if (search) {
                        seedNum = value + (soilNum-key.lowerBound)
                        break
                    }
                }
                
                // check if seed exists
                var seedExists = false
                for seed in seeds {
                    let search = seed.contains(seedNum)
                    if (search) {
                        seedExists = true
                        break
                    }
                }
                
                if (seedExists) { break }
                
                // new location to check
                locationNum += 1
            }
            print(locationNum)
        } catch {
            print(error)
        }
    }
    
    // custom error handling
    private enum Day5Error: Error {
        case invalidStatus(status: Int)
    }
}
