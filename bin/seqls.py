#!/usr/bin/env python
import os, sys
#from sets import Set
path = 'Z:/job/TOTEM/SHOTS/AZ003/Frames/render/character/'
files = os.listdir(path)

finalSeqList = []

def padFrame(frame,pad):
    return '0' * (pad - len(str(frame))) + str(frame)

def seqLS (dirPath):
    files = os.listdir(dirPath)
    for file in files:
        try:
            prefix, frame, suffix = file.split('.')
    
            # build a dictionary of the sequences as {name: frames, suffix}
            #
            # eg beauty.01.tif ... beauty.99.tif  will convert to
            # { beauty : [01,02,...,98,99], tif }
    
            try:
                result[prefix][0].append(frame)
            except KeyError:
                # we have a new file sequence, so create a new key:value pair
                result[prefix] = [[frame],suffix]   
        except ValueError:
            # the file isn't in a sequence, add a dummy key:value pair
            result[file] = file
    
    
    for prefix in result:
        if result[prefix] != prefix:
            frames = result[prefix][0]
            frames.sort()
    
            # find gaps in sequence
            startFrame = int(frames[0])
            endFrame = int(frames[-1])
            pad = len(frames[0])
            idealRange = set(range(startFrame,endFrame))
            realFrames = set([int(x) for x in frames])
            # sets can't be sorted, so cast to a list here
            missingFrames = list(idealRange - realFrames)
            missingFrames.sort()
    
            #calculate fancy ranges
            subRanges = []
            for gap in missingFrames:
                if startFrame != gap:
                    rangeStart = padFrame(startFrame,pad)
                    rangeEnd  = padFrame(gap-1,pad)
                    subRanges.append('-'.join([rangeStart, rangeEnd]))
                startFrame = gap+1
                
            subRanges.append('-'.join([padFrame(startFrame,pad), padFrame(endFrame,pad) ]))
            frameRanges = ','.join(subRanges)
            frameRanges = '[%s]' % (frameRanges)
            suffix = result[prefix][1]
            sortedList.append('.'.join([prefix, frameRanges ,suffix]))
            print ('\t' + '.'.join([prefix, frameRanges ,suffix]))
        else: sortedList.append(prefix)
   
    
if __name__ == '__main__':
    if len(sys.argv) > 1:
        path = sys.argv[1]
        
    for root, dirs, files in os.walk(path):
        for curDir in dirs:
            fulldir = os.path.join(root, curDir)
            print 'Scanning : %s' % (fulldir)
            result = {}
            sortedList = []
            seqLS(fulldir)