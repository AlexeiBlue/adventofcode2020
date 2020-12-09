const fs = require('fs');

var instructionsRan = new Set();
var instructionIndex;
var accumulator;

function infiniteRun(instructionSet) {
  instructionsRan.clear();
  instructionIndex = 0;
  accumulator = 0;

  while (instructionIndex <= instructionSet.length) {
    var instruction = instructionSet[instructionIndex];

    if (instructionsRan.has(instructionIndex)) {
      console.error("Duplicate instruction " + instruction + "@" + instructionIndex);
      return true;
    }
    instructionsRan.add(instructionIndex);
    
    switch(instruction.substr(0,3)) {
      case "nop" : 
        instructionIndex++;
        break;
      case "acc" :
        accumulator += Number(instruction.substr(4));
        instructionIndex++;
        break;
      case "jmp" : 
        instructionIndex += Number(instruction.substr(4));
        break;
      default :
        console.error("Instruction not recognised " + instruction.substr(0,3));
        process.exit(1);
    }
  }
}

var instructions = fs.readFileSync('./puzzle8[input]').toString().split("\n");

instructions.forEach(function(instruction, index) { 
  var instructionKey = instruction.substr(0,3);
  var instructionVal = instruction.substr(4);
  if (instructionKey != "acc") {
    var instructionSet = [...instructions];

    instructionSet[index] = (instructionKey == "jmp" ? "nop " : "jmp ") + instructionVal;
    
    if (!infiniteRun(instructionSet)) {
      console.log(accumulator);
      process.exit();
    }
  }
});

console.log("No finite execution found");
process.exit(1);
