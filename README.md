#  Pokedex

## Introduction

This project is a practice of SwifUI and Combine.
It's a simple List-Detail APIRest and communicates with [the Pokéapi webservice] (https://pokeapi.co).

## Features

User choose a pokemon in the list and show his detail.
The application supports 3 languages ​​(English, French and German) depending on the language of the device.
On settings user can, delete the content and choose a pokemon generation.

## Architecture

This is a MVVM architecture and use SwiftUI and Combine for reactive programming.
The project also uses Swift Package Manager which distributes my personal library under XCFramework.
I use my DataLoader for download audio and image files (store then and caches).
And CoreData for manage persistence.

## Environnement

- Xcode 12
- Swift 5.3
- SwiftUI, Combine, CoreData, AVFoundation
- SPM, XCFramework
