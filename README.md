# barfotron6000
povray multiaxis spinner toy

this is a povray scene that creates a looping dizzy animation. it can be rendered using the following:

`povray myscene.pov +KFF600 +KC`

see [Animation Options](https://wiki.povray.org/content/Reference:Animation_Options) and [Output Options](https://wiki.povray.org/content/Reference:General_Output_Options) for related settings.

and then ffmpeg to create a 60 fps video:

`ffmpeg -r 60 -loop 1 -t 10 -i "frames\myscene%%03d.png" -pix_fmt yuv420p scene_movie.mp4`

(note, the discatte shape was left out to keep the scene simple, you may find a copy here https://github.com/discatte/spincatte)

https://www.youtube.com/watch?v=yFFGBCNNzgk

![still at clock 0.15](https://github.com/discatte/barfotron6000/raw/main/sharper%20image%20ring%20toy%20selfie%20loop.png)
