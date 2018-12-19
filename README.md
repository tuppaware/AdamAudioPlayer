# AdamAudioPlayer
A swift based audio player that lets you easily manage multiple files at once using AVFoundation and a simple singleton instance. Makes it easy to play/pause and stop files, identifiers are stored in Local Storage. Its very beta at the moment.

## Installation
Download, drag into your xcode project (pod coming soon).

## Play/Pause and Stop files
### Playing a file. 
Noting that playback is set to loop automatically until you stop it.  

Swift 
```
AdamAudioPlayer.shared.play(identifier: "MySound", fileName: "My_sound.mp3")
```

Objective C
```
[[AdamAudioPlayer shared] playWithIdentifier:@"MySound" fileName:@"My_sound.mp3" inDocuments:NO];
```

### Pause one file

Swift 
```
AdamAudioPlayer.shared.pauseSound(identifier: "MySound")
```

Objective C
```
[[AdamAudioPlayer shared] pauseSoundWithIdentifier:@"MySound"]];
```

### Pause/ Resume all files
Swift 
```
AdamAudioPlayer.shared.pauseAll()

AdamAudioPlayer.shared.resumeAll()
```

Objective C
```
[[AdamAudioPlayer shared] pauseAll]];

[[AdamAudioPlayer shared] resumeAll]];
```

### Stop one file
Noting that Stopping one or all files also removes the audio object, means you'll have to recreate the it again to use it.

Swift 
```
AdamAudioPlayer.shared.stopSound(identifier: "MySound")
```

Objective C
```
[[AdamAudioPlayer shared] stopSoundWithIdentifier:@"MySound"]];
```
### Stop all files

Swift 
```
AdamAudioPlayer.shared.stopAll()
```

Objective C
```
[[AdamAudioPlayer shared] stopAll]];
```
### What files are playing ?

Swift 
```
// return an array of sound identifiers
let whatsPlaying = AdamAudioPlayer.shared.whatsPlaying()

// Check one file is playing ? Returns a bool.
let isMySoundPlaying =  AdamAudioPlayer.shared.isPlayingWith(identifier: "mySound")
```
Objective C
```
// return an array of sound identifiers
NSArray * whatsPlaying = [[AdamAudioPlayer shared] whatsPlaying];

// Check one file is playing ? Returns a bool.
BOOL isMySoundPlaying = [[AdamAudioPlayer shared] isPlayingWithIdentifier:"mySound"]];
```

## Volume Control

Swift 
```
// change volume of single sound as a float 0.0 - 1.0
AdamAudioPlayer.shared.changeVolumeOf(identifier:"mySound", volume: 0.5)

// change volume of all sounds
AdamAudioPlayer.shared.changeVolumeOfAll(volume: 0.5)

// Method to retrieve volume of sounds coming soon 
```
Objective C
```
// change volume of single sound as a float 0.0 - 1.0
AdamAudioPlayer.shared.changeVolumeOf(identifier:"mySound", volume: 0.5)

// change volume of all sounds
[[AdamAudioPlayer shared] changeVolumeOfIdentifier:"mySound" volume:0.5]];
```

## Extras

When selecting a file you can tell AdamAudioPlayer if the file is in the Cache folder (within Documents), this is handy if have audio files that you download into a non-icloud backup folder.

## To-do

Methods to return volume.
Cocoapod implementation.
Better error handling.
