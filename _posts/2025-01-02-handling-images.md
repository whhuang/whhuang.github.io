---
category: website
title: Handling images
date: 2025-01-02 10:00:00
---

I just spent an absurd amount of time trying to figure out how to deal with images on this blog. I've decided to upload images directly into the repository under `assets/images` as a first pass (this may become unscalable pretty quickly, but we'll see how far I get).

### Issue 1: files are too large to upload

This would've been a lot easier to debug if I got a message as I entered `git push` that said, "hey, your files are really large, have you considered using git-lfs?" (LFS = Large File Storage, my understanding is it's how git avoids pulling down copies of large files by providing a pointer to them instead). That would've been way too easy though. Instead, I got this fun message:

```
$ git push
Enumerating objects: 28, done.
Counting objects: 100% (28/28), done.
Delta compression using up to 8 threads
Compressing objects: 100% (21/21), done.
error: RPC failed; HTTP 400 curl 22 The requested URL returned error: 400
send-pack: unexpected disconnect while reading sideband packet
Writing objects: 100% (21/21), 110.36 MiB | 38.41 MiB/s, done.
Total 21 (delta 4), reused 0 (delta 0), pack-reused 0
fatal: the remote end hung up unexpectedly
Everything up-to-date
```

Since I'm in a new location and have various VPNs running in the background, my initial reaction was that the wifi wasn't strong enough or that it was spotty. I tried again and again, and I kept getting the same error. My next thought was that the files might be too large since it was my first time adding images to the repo. ChatGPT confirmed my suspicions, but it would've been real nice if git just told me that from the get-go...

So, I enabled git-lfs and followed ChatGPT's instructions:
```
$ git lfs install
$ git lfs track "*.png"
$ git add .gitattributes
```
It took me a few tries to get it exactly correct (my images weren't getting picked up by lfs initially for some reason, probably because I'm bad at following simple instructiions).

### Issue 2: images weren't displaying on published site

So the images were displaying just fine in the local version of my website. ChatGPT suggested the issue was because my paths were defined incorrectly - perhaps the relative paths change upon publishing the site. I tried the various options proposed on [this page](https://mademistakes.com/mastering-jekyll/site-url-baseurl/) but to no avail.

I inspected the image elements and it seemed like the URLs were resolving in a reasonable way, but no image was getting displayed. Perhaps my images were too large? I didn't downsize them from the original iPhone photos, so they were close to 4K res images (over 10MB). I didn't want to manually rescale the images via Mac Preview or Photoshop/GIMP, so I used [ImageMagick](https://imagemagick.org) which I've historically had a lot of luck with. It provides a nice command line interface to let you programmatically apply conversions and transformations to your images, which is great if you have a lot of images to process. I ran a simple `-convert` command on all my images to downsize them, and it seemed to work, except for one weird thing - the colors on all of my images were super washed out. The bright photos looked vintage, the dark photos got more gray. It really puzzled me because resize (especially downsizing) is a very simple operation, and even an algorithm that averages pixel values would not have resulted in the images I was seeing. I went back-and-forth with ChatGPT a dozen times to see if there were any flags I could pass in to the command to preserve the initial image quality, and nothing seemed to work.

Eventually I got a nugget of information that the color profiles between the original and resized photos might be different. The original color profile was `Display P3; SMPTE ST 2084 PQ`, but after resizing, it changed to `Display P3 Primaries; PQ (Gain Map Preview 465D7D25EBBF72A8)`. I know nothing about color profiles, but it seemed like my main goal should be to make sure that ImageMagick doesn't change the color profile at the very least. Nothing seemed to work. After a tiny bit of digging, I found out the color profiles were related to HDR (which makes sense why they would look so washed out without proper HDR handling), and ChatGPT suggested using [ffmpeg](https://www.ffmpeg.org/) instead. Yep, that worked like a charm.

All that said and done, I reuploaded the downsize images which were now on the order of 1MB and waited excitedly. Still no dice. Alright, perhaps the server isn't finding the images in the first place, potentially because of git-lfs. (For what it's worth, this was one of my initial thoughts, but ChatGPT was the one who led me astray...) I found this post and followed [these instructions](https://github.com/orgs/community/discussions/50337#discussioncomment-5349819), which I'm embarrassed to say took me a bit longer than expected. I'm a big fan of very specific and clear instructions, so as an amendment to the post, step 1 should actually be:

1. Change your site's source from Branch to GitHub Actions in the settings:
  - Go to repo "Settings"
  - Go to "Pages" on the sidebar
  - Then under Build and Deployment > Source switch from Branch to GitHub Actions

I selected the default Jekyll build action, but had I known that GitHub Pages supports arbitrary actions for deploying to pages, I could've used something other than Jekyll to begin with. Oh well, I'm a bit too far deep in at this point, and I don't actually hate Jekyll for this use case.

In addition to enabling lfs in the `jekyll.yml` actions file, I had to amend the `Setup Ruby` step since I had been building locally on my Mac, but GHA uses an Ubuntu machine to build and deploy the website. `bundle lock --add-platform arm64-darwin x86_64-linux` and committing the `Gemfile.lock` edits did the trick. There were a few additional small things with the specific version of Ruby which ChatGPT helped resolve very quickly.

I was feeling pretty good about this one now. The action ran successfully, I refreshed my browser and...still no dice. Before I absolutely lost my mind, I cleared my browser cache and the images appeared! Hooray!