struct Dog {
    let name:String
    let colour:String
}

let dogs = [Dog(name: "Retriever", colour: "Golden"),Dog(name: "Mongrel", colour: "Brown"),Dog(name: "Daschund", colour: "Brown"),Dog(name: "Red setter", colour: "Red")]

//create an array containing only Brown dogs.
func mutableBrownDogFilter(dogs:Array<Dog>) -> Array<Dog> {
    var result = Array<Dog>() //mutable array
    for dog in dogs {
        if dog.colour == "Brown" {
            result.append(dog)
        }
    }
    return result
}

print(mutableBrownDogFilter(dogs: dogs))

func brownDogFilter(dogs:Array<Dog>) -> Array<Dog> {
    
    if let firstDog = dogs.first { //if the array is empty, first returns nil
        let remainingDogs = Array(dogs.dropFirst()) //have to case an arraySlice to an array
        if firstDog.colour == "Brown" {
            return [firstDog] + brownDogFilter(dogs: remainingDogs)
        } else {
            return brownDogFilter(dogs: remainingDogs)
        }
    } else {
        return [] //if nothing left in the array, end the recursion
    }
}

print(brownDogFilter(dogs: dogs))

//This uses less memory. In the previous version the function keeps getting added to the stack, but on this version the compiler discards each function at each return
func brownDogFilterTailRecursion(dogs:Array<Dog>, result:Array<Dog>=[]) -> Array<Dog> {
    
    if let firstDog = dogs.first { //if the array is empty, first return nil
        let remainingDogs = Array(dogs.dropFirst()) //This is often called the "tail" of the list
        if firstDog.colour == "Brown" {
            return brownDogFilterTailRecursion(dogs: remainingDogs, result: result + [firstDog]) //append the data to the result which is then passed as a paramter
        } else {
            return brownDogFilterTailRecursion(dogs: remainingDogs, result:result) //result hasn't changed so call function again with same result as before
        }
    } else {
        return result
    }
}

print(brownDogFilterTailRecursion(dogs: dogs))

//You coud use map or filter in this simple example
let mappedDogs:Array<Dog> = dogs.compactMap{dog in if dog.colour == "Brown" {return dog} else {return nil}} //you provide function to convert each element into something else. nils don't get written to the array.
print(mappedDogs)
let filteredDogs = dogs.filter{$0.colour == "Brown"} // you provide a function to filter each element
print(filteredDogs)

//Reduce is used to accumulate a result, e.g. count the number of brown dogs. You provide a function that usually adds something to a running total.
let numberOfBrownDogs = dogs.reduce(0){ (total, dog) -> Int in if dog.colour == "Brown" {return total + 1} else {return total + 0 }  } //adds 1 to the total each time it is a brown dog
print("No of brown dogs is \(numberOfBrownDogs)")

//Swift tuples make it easy to keep accumulate more than one thing
let numberOfBrownAndOtherDogs = dogs.reduce((brown:0,other:0)){ (total, dog) -> (brown:Int, other:Int) in if dog.colour == "Brown" {return (total.brown + 1, total.other)} else {return (total.brown, total.other + 1) }  }
print("No of brown dogs is \(numberOfBrownAndOtherDogs.brown), no of other dogs \(numberOfBrownAndOtherDogs.other) ")


//Reduce could be used to create a new array of dogs
let reducedDogs = dogs.reduce(Array<Dog>()){ (total, dog) -> Array<Dog> in if dog.colour == "Brown" {return total + [dog]} else {return total}  }
print(reducedDogs)
