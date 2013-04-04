#Panic Button
===================

A userspace driver for "novelty" USB Panic buttons [like this one](http://www.firebox.com/product/1742/USB-Panic-Button)

This project initially grew out of a desire to do something non-trivial with this USB button I acquired years ago at an old job. The software it ships with is a really terrible win32 form that displays some static images. It's actually a lot of fun to flip the lid and press the button (in an emergency, say), so I wanted to figure out how to interface with it and do something custom.

Currently this project is also a stomping ground for learning more about OS X, so there's also some experimentation with technology that I think is cool, but is unnecessary.

*Build Instructions*
If you want to build this and run it today, you should probably download XCode from the App Store, fork my project and build the only target, PanicButton.app -- it's a background only application but it sets up a NSStatusBar menu item with some custom actions in it.
