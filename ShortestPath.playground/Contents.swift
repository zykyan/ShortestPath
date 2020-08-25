import UIKit

//var str = "Hello, playground"

// Shortest Path
// Have the function ShortestPath(strArr) take strArr which will be an array of strings
// which models a non-looping Graph.
// The structure of the array will be as follows:
//  The first element in the array will be the number of nodes N (points) in the array as a string.
//  The next N elements will be the nodes which can be anything (A, B, C .. Brick Street, Main Street .. etc.).
// Then after the Nth element, the rest of the elements in the array will be the connections between all of the nodes.
// They will look like this: (A-B, B-C .. Brick Street-Main Street .. etc.).
// Although, there may exist no connections at all.

// An example of strArr may be: ["4","A","B","C","D","A-B","B-D","B-C","C-D"]. Your program should return the shortest path from the first Node to the last Node in the array separated by dashes. So in the example above the output should be A-B-D. Here is another example with strArr being ["7","A","B","C","D","E","F","G","A-B","A-E","B-C","C-D","D-F","E-D","F-G"]. The output for this array should be A-E-D-F-G. There will only ever be one shortest path for the array. If no path between the first and last node exists, return -1. The array will at minimum have two nodes. Also, the connection A-B for example, means that A can get to B and B can get to A.
// Examples
// Input: ["5","A","B","C","D","F","A-B","A-C","B-C","C-D","D-F"]
// Output: A-C-D-F
// Input: ["4","X","Y","Z","W","X-Y","Y-Z","X-W"]
// Output: X-W
// Here is the structure of the code :


func ShortestPath(_ strArr: [String]) -> String {
    let numberOfNodes = Int(strArr[0]) ?? 0
    if(numberOfNodes == 0){
        return "Invalid or ZERO nodes in the array";
    }
    
    let nodes = Array(strArr[1..<numberOfNodes+1])
    
    let connections = Array(strArr[numberOfNodes+1..<strArr.count])
    
    if(connections.count == 0){
        return "No connections found."
    }
    
    var connectionDict:[String:[String]] = [:]
    var key = ""
    var value = ""
    
    for connection in connections{
        let sourceAndDestination = connection.components(separatedBy: "-")
        key = sourceAndDestination[0]
        value = sourceAndDestination[1]
        if (connectionDict[key] != nil){
            connectionDict[key]?.append(value)
        }else{
            connectionDict[key] = [value]
        }
        
        key = sourceAndDestination[1]
        value = sourceAndDestination[0]
        
        if (connectionDict[key] != nil){
            connectionDict[key]?.append(value)
        }else{
            connectionDict[key] = []
            connectionDict[key] = [value]
        }
    }
    
    
    var start = [nodes.first!]
    var end = [nodes.last!]
    var shortestPathDict:[String:[String]] = [:]
    var numberOfCalls = 0
    
    
    func searchDict(nodes: [String]){
        numberOfCalls += 1
        if(numberOfCalls >= connections.count * 10){
            print("No Path Found")
        }
        
        var moveForward = true
        var toBeAdded = [String]()
        var connectedToAddToDict = [String]()
        var newSearch = [String]()
        var newAdditions = [String]()
        
        for node in nodes{
            if (shortestPathDict[node] == nil){
                toBeAdded.append(node)
            }
        }
        
        for node in toBeAdded{
            connectedToAddToDict = connectionDict[node]!
            
            for anItem in connectedToAddToDict{
                if(shortestPathDict[anItem] == nil && !nodes.contains(anItem)){
                    newAdditions.append(anItem)
                }
            }
            
            for anItem in newAdditions{
                if(!newSearch.contains(anItem)){
                    newSearch.append(anItem)
                }
            }
            
            shortestPathDict[node] = newAdditions
            newAdditions = []
        }
        
        for node in newSearch{
            if (node == end[0]){
                moveForward = false
            }
        }
        
        if moveForward{
            searchDict(nodes: newSearch)
        }
        
    }
    searchDict(nodes: start)
    
    var arrPath = [String]()
    var finalStr = ""
    
    func dictionaryToString(lookingFor:String)->String{
        var lookingForKey = lookingFor
        if(lookingForKey == end.first!){
            arrPath.append(lookingForKey)
        }
        
        for (key, values) in shortestPathDict{
            if(values.contains(lookingFor)){
                arrPath.append(key)
                lookingForKey = key
                if(lookingForKey == start.first!){
                    finalStr = arrPath.reversed().joined(separator: "-")
                    break
                }else{
                    dictionaryToString(lookingFor: lookingForKey)
                }
            }
        }
        return finalStr;
    }
    return "Shortest Path is -> " + dictionaryToString(lookingFor: end.first!)
}

//print(ShortestPath(readLine(stripNewline: true)));
//print(ShortestPath(["7","D","A","N","I","E","L","B","D-A","A-N","E-B","E-L"]))
print(ShortestPath(["7","A","B","C","D","E","F","G","A-B","A-E","B-C","C-D","D-F","E-D","F-G"]))
