#!/usr/bin/env python3

import math
import random
import sys

def arrayFromFile(filename):
    with open(filename) as file_pointer:
        content = file_pointer.read()

    return content.split('\n')

def stats():
    return len(doWords)*len(describeWords)*len(actorWords)*1000

def stekword():
    """Generates and returns Stek-Password based string"""
    return "{do}{counter}{describe}{actor}".format(
        do = doWords[random.randint(1, len(doWords)) - 1],
        counter = random.randint(0, 999),
        describe = describeWords[random.randint(1, len(describeWords)) - 1].capitalize(),
        actor = actorWords[random.randint(1, len(actorWords)) - 1].capitalize()
    )

doWords = arrayFromFile("doWords.txt")
describeWords = arrayFromFile("describeWords.txt")
actorWords = arrayFromFile("actorWords.txt")

if __name__ == '__main__':
    for i in range(1, len(sys.argv)):
        if sys.argv[i] == "-h" or sys.argv[i] == "--help":
            print("Usage {} NUMBER_OF_WORDS SEPARATOR".format(sys.argv[0]))
            print("Possible combinations: {}".format(stats()))
            sys.exit(0)

    if len(sys.argv) > 1:
        try:
            numWords = int(sys.argv[1])
        except ValueError:
            sys.stderr.write("First argument must be a {} received a {}\n".format(int, type(sys.argv[1])))
            sys.exit(1)

        if numWords > stats():
            sys.stderr.write("You cannot request more than {} stekwords. Your number of words cannot be generated.\n".format(stats()))
            sys.exit(1)
    else:
        numWords = 1

    if len(sys.argv) > 2:
        separator = sys.argv[2]
        separator = separator.replace("\\n", "\n")
    else:
        separator = "\n"
    
    usedWords = []
    while len(usedWords) < numWords:
        thisWord = stekword()
        if thisWord in usedWords:
            sys.stderr.write("Fond a collision {} was already in the list\n".format(thisWord))
            continue
        usedWords.append(thisWord)

    print(separator.join(usedWords))