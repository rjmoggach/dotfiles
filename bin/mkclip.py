#!/usr/bin/env python

import sys
import os
import re
import xml.dom.minidom as minidom
import optparse
import shutil


def addFeed(feed,vuid,targetMIO,trackUID):
    tracks = targetMIO.getElementsByTagName('track')
    newID = vuid
    #Iterate through the tracks, looking for perfect matches for the incoming feed
    for i in range(len(tracks)):
        if tracks[i].attributes["uid"].value == trackUID:
            if ( len(vuid) == 0 ):
                #Get the version of the last feed
                allfeeds = tracks[i].getElementsByTagName('feed')
                for j in range(len(allfeeds)):
                    feedID = allfeeds[j].attributes["uid"].value
                    if feedID == "v0":
                        newID = "002"
                    else:
                        match = re.search( "([\d]+)", feedID)
                        if match:
                            number = int(match.group(1))
                            number = number + 1
                            newID = "%03d" % number
                        else:
                            print "Invalid feed uid in masterfile: %s" % feedID
                            sys.exit(2)
            feed.attributes['vuid'].value = newID
            feed.attributes['uid'].value = newID
            #When the feed's track matches the one in the clip, add the feed to this track
            tracks[i].getElementsByTagName('feeds')[0].appendChild(feed)
    return newID


def splice( masterFile, newFile ):
    #Read the Gateway Clip XML files for the existing and new versions
    sourceGWXML = minidom.parse(masterFile)
    newGWXML = minidom.parse(newFile)
    #Get all of the tracks from the new
    allTracks = newGWXML.getElementsByTagName('track')
    newVersionID = ''
    for i in range(len(allTracks)):
        theTrackID = allTracks[i].attributes["uid"].value
        theTrack = allTracks[i]
        theFeed = theTrack.getElementsByTagName('feed')[0]
        newVersionID = addFeed(theFeed,newVersionID,sourceGWXML,theTrackID)
    #Add a version description at the end of the file, for this new version
    doc   = minidom.Document()
    newVersion = sourceGWXML.getElementsByTagName('versions')[0].appendChild(doc.createElement('version'))
    newVersion.setAttribute('type', 'version')
    newVersion.setAttribute('uid', newVersionID)

    resultXML = sourceGWXML.toxml()

    # Create a backup of the original file
    bakfile = "%s.bak" % masterFile
    if not os.path.isfile(bakfile):
        shutil.copy2(masterFile,bakfile)
    else:
        created = False
        for i in range ( 1, 99 ):
            bakfile = "%s.bak.%02d" % ( masterFile, i )
            if not os.path.isfile(bakfile):
                shutil.copy2(masterFile,bakfile)
                created = True
                break
        if not created:
            bakfile = "%s.bak.last" % masterFile
            shutil.copy2(masterFile,bakfile)

    outFile = masterFile

    print " Adding feed version %s" % newVersionID
    f = open(outFile, "w")
    f.write( resultXML )
    f.close()


###################################################################
#
# MAIN
#
###################################################################

if __name__=='__main__':
    parser = optparse.OptionParser()

    parser.add_option("--clip", dest="clipFile", help="clip file to create or append to if already created" )
    parser.add_option("--folders", dest="folders", help="list of folders, comma separated to add to clip file as incremental versions " )

    (options, args) = parser.parse_args()

    if options.clipFile is None:
        parser.print_help()
        sys.exit(2)

    if options.folders is None:
        parser.print_help()
        sys.exit(2)

    folders = options.folders.split(",")

    for folder in folders:
        if not os.path.isdir(folder):
            print "The following folder does not exist: %s" % folder
            sys.exit(2)

    getMediaScript = "/usr/discreet/mio/current/dl_get_media_info"

    if not os.path.isfile(getMediaScript):
        print "The get media info script is not installed: file %s missing" % getMediaScript
        sys.exit(2)

    if not os.path.isfile(options.clipFile):
        # create it
        initialpath = os.path.abspath(folders[0])
        print " creating file with folder %s" % initialpath

        res = os.popen4("%s -r %s" % ( getMediaScript, initialpath ) )[1].readlines()

        f = open(options.clipFile, "w")
        for line in res:
            f.write( line )
        f.close()

        del folders[0]

    tmpfile = "tmpfile"

    for folder in folders:
        apath = os.path.abspath(folder)
        print " Adding folder %s" % apath
        #output a temp file
        if os.path.isfile(tmpfile):
            os.remove(tmpfile)
        res = os.popen4("%s -r %s" % ( getMediaScript, apath ) )[1].readlines()

        f = open(tmpfile, "w")
        for line in res:
            f.write( line )
        f.close()
        splice(options.clipFile,tmpfile)

    if os.path.isfile(tmpfile):
        os.remove(tmpfile)
