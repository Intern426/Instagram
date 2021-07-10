# Project 4 - *Pseudo-Instagram*

**Pseudo-Instagram** is a photo sharing app using Parse as its backend.

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [ ] Style the login page to look like the real Instagram login page.
- [ ] Style the feed to look like the real Instagram feed.
- [X] Implement a custom camera view.

The following **additional** features are implemented:

- [x] List anything else that you can get done to improve the app functionality!
- If phone has a camera, an alert shows up asking them if they want to take a picture or selecting a picture from their camera roll instead. Additionally, if you're looking at a user's profile, the button that says Save Changes will be hidden and the profile image is no longer clickable. 

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. It would be nice to discuss Parse, especially if we plan on using its database for our project
2. It would also be nice to clarify what exactly the Navigation Controller does and how the different segues are supposed to be used. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![](https://i.imgur.com/bESFMGV.gif)
![](https://i.imgur.com/XRi7JMz.gif)
![](https://i.imgur.com/msB7AIa.gif)
![](https://i.imgur.com/pIR7Qok.gif)
![](https://i.imgur.com/5OKy6Zc.gif)
![](https://i.imgur.com/Sb7uVIP.gif)
![](https://i.imgur.com/Qk78STa.gif)


GIF created with [Kap](https://getkap.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

Describe any challenges encountered while building the app.

Since there were a lot of view controllers that ended up intersecting, it was a little tricky determining (i.e. remembering) which segue to use and where to put the protocols/delegates - causing a lot of exceptions about due to a missing segue identifier or even seguing to the wrong view Controller. Ultiimately, I was able to clean it all up but it was interesting to work around this. 

Figuring out how Parse worked and trying to save the user's profile image was a little difficult at the beginning. It was interesting how gathering any key value with a String or number required you to use [@"key"] but trying to get the author required post.author. This nuance tripped me up for a while when accessing/updating data in author. 


## License

    Copyright [2021] [Kalkidan Tamirat]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.