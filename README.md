# Memento Mori 💀

After turning 30, I decided to make a little app that helps me take a moment to reflect on the preciousness of time. So, let me introduce you to **memento mori**, a little **Playdate app** that helps you **visualize your estimated life expectancy and the time you have left**. The name "memento mori" is a Latin phrase that translates to **"remember that you die"**.

## Description of App 📱

This little app offers a gentle perspective on your estimated lifespan, using **statistical data**. After a **quick initial setup**, it displays:

- Your **estimated life expectancy**.
- The **approximate time you might have remaining** in years, months, weeks, and days.
- The **percentage of your estimated life already lived**.

It also has a neat **"lockscreen" mode**! ✨ In this mode, the screen update rate slows right down to **1 frame per second (FPS)**, and the Playdate's **automatic screen lock is disabled**. This lets the **display stay on continuously** while sipping **minimal battery power** 🔋

You can grab the **compiled app** from [itch.io](https://divingavran.itch.io/memento-mori). If you enjoy tinkering with code, feel free to **download the source code** from this repository and **compile it yourself using `pdc`** 🧑‍💻

## Information on Source Code 🧑‍💻

This project is just a simple **Playdate app** built using the **official Playdate SDK**. It's written in **Lua** and uses the **Playdate's built-in graphics and input libraries**. I've done my best to make the code readable, adding comments here and there to explain things. 📝 The code is separated into different files / folders to hopefully keep things organized. The main files / folders are:

- `main.lua`: The **main entry point** of the application. It **initializes the app** and **handles the main game loop**.
- `scenes`: This folder contains the **different scenes** of the app, including the **main scene `game.lua`** and the **intro scenes** for the setup process (see `intro`).
- `objects`: This folder contains the **different reusable bits** used in the app, like the **battery indicator**, the **button layout**, the **clock**, and the **overview object**.

## Support 💖

If you find this little app or its source code helpful, maybe consider **supporting my work**? 😊 You can find me on **[Ko-fi](https://ko-fi.com/divin)** or leave a **small donation via [itch.io](https://divingavran.itch.io/memento-mori)**. **Any support truly helps** me keep tinkering and hopefully improving things! Thank you! 🙏

## Credits 🙏

- **[LuaCATS](https://github.com/notpeter/playdate-luacats)**: Types for the Playdate SDK API.
- **WHO Data**: The **life expectancy data** comes courtesy of the **World Health Organization**. I did some minor tidying and put it into a **Lua table** (check the `data` folder!). Unfortunately, I can't seem to find the original source link anymore, sorry about that!
- **UI Sounds**: The lovely **UI sounds** are from [Pixabay](https://pixabay.com). I did some minor editing to make them fit just right. You can find the sounds in the `source/assets/sounds` folder. Apologies, but I downloaded several sounds before picking the final ones, so I don't have the specific links handy anymore.
- **[ADPCM](https://devforum.play.date/t/adpcm-encoder-tool-mac-only/1283)**: Used the ADPCM encoder tool from [Matt Sephton](https://blog.gingerbeardman.com/about). Thanks, _matt_! 🙏
