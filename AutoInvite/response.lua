if AutoInvite.response then return end

local responses = {
  "The owl flies at midnight.",
  "Bananas are excellent swimmers.",
  "Timmy!",
  "Do you hear the whispers of the wind?",
  "Quantum entanglement is quite the pickle.",
  "A spoonful of stars, please.",
  "Never trust a cat wearing sunglasses.",
  "The sky is made of waffles.",
  "I once knew a penguin who danced.",
  "The moon owes me a favor.",
  "All roads lead to the jellyfish convention.",
  "Have you seen my invisible hat?",
  "Purple elephants are surprisingly punctual.",
  "Time is just a flat circle of toast.",
  "A whispering cucumber told me this.",
  "Don't forget to water your brick collection.",
  "The universe hiccuped yesterday.",
  "42 is not the answer; it's a question.",
  "I prefer my pancakes nocturnal.",
  "Tigers love jazz music.",
  "Did you feed the clock today?",
  "Rainbows are allergic to sarcasm.",
  "Never underestimate the power of a sleeping otter.",
  "Pineapples are secretly plotting.",
  "The fish knows too much.",
  "Sometimes, the answer is spaghetti.",
  "Beware the dancing shadows at dawn.",
  "Your keyboard is whispering secrets.",
  "I lost my time machine at the beach.",
  "The cactus dreams of the ocean.",
  "Potatoes have feelings too.",
  "Butterflies once ruled the world.",
  "A rubber duck knows your true name.",
  "The stars are gossiping about you.",
  "Have you hugged a dragon today?",
  "Don't trust a snail wearing a top hat.",
  "Is that your final watermelon?",
  "The sun sneezed, and we got rainbows.",
  "Pine trees love opera.",
  "A hamster just won the lottery.",
  "The toaster demands a sacrifice.",
  "Beware the purple fog.",
  "Did you just hear the ice cream truck?",
  "Clouds are plotting a rebellion.",
  "One sock always escapes the dryer.",
  "Bees dream of jazz music.",
  "Your shadow is running late.",
  "The dictionary forgot your name.",
  "Snakes secretly play poker.",
  "Today is a perfect day for unicorns.",
  "The clock ticks backward on Wednesdays.",
  "Llamas invented karaoke.",
  "A whisper from the void greets you.",
  "Cows can't juggle in space.",
  "The stars hum a lullaby for frogs.",
  "Mushrooms are expert philosophers.",
  "Time loops are just cosmic pranks.",
  "The pizza has spoken.",
  "Squirrels know the secrets of the universe.",
  "Don't wake the snoring volcano.",
  "The moon is a cheese factory.",
  "Tuna fish prefer board games.",
  "Is that a banana in disguise?",
  "The vacuum cleaner ate my socks.",
  "Cats are the real rulers of Pluto.",
  "Beware the silent jellybeans.",
  "Your reflection has a secret life.",
  "Koalas write poetry at midnight.",
  "Every turtle hides a story.",
  "Space pirates love peanut butter.",
  "Rain drops are the tears of clouds.",
  "The chair is watching you.",
  "Chameleons are terrible at charades.",
  "Don't argue with a wise old potato.",
  "The piano misses its keys.",
  "Invisible sandwiches taste the best.",
  "The stars winked just for you.",
  "Why did the bubble pop?",
  "Snails are faster when they're happy.",
  "Your shoelaces are plotting revenge.",
  "The wind has a favorite song.",
  "Beware the cupcake with a plan.",
  "Your left sock says hello.",
  "The ducks know your secrets.",
  "Once, I saw a chair walk.",
  "The void is surprisingly friendly.",
  "Who taught the toaster to dance?",
  "The alarm clock is lying to you.",
  "Rainbows are nature's paintbrush.",
  "Penguins are planning a world tour.",
  "The stars laughed last night.",
  "Do not question the wisdom of waffles.",
  "Your mirror has an opinion.",
  "Why is the tomato so quiet?",
  "The clock smiled at midnight.",
  "Shadows love to play hide and seek.",
  "All triangles are secretly plotting.",
  "The wind has a favorite color.",
  "Does the sofa dream of flying?",
  "The stars are allergic to peanut butter.",
  "The clock argued with the toaster again.",
  "I gave the cactus a bowtie.",
  "Spaghetti sings in the rain.",
  "Why did the penguin borrow my socks?",
  "Do stars write love letters to the moon?",
  "A jellybean whispered a prophecy.",
  "The library is full of untold secrets.",
  "Why does the rain smell like pancakes?",
  "The kettle learned to whistle yesterday.",
  "Don't feed the mischievous marshmallows.",
  "I caught the table reading poetry.",
  "The lamp danced at midnight.",
  "Do clouds gossip about airplanes?",
  "The shadows hid under the bed again.",
  "Pineapples are running for office.",
  "The book told me not to trust the bookmark.",
  "The wallpaper is planning a mutiny.",
  "Don't anger the broomstick.",
  "Do pencils dream of being pens?",
  "The toaster won the talent show.",
  "Your left shoe just winked at me.",
  "The stars debated philosophy last night.",
  "The river hummed a blues tune.",
  "Do butterflies have regrets?",
  "The clock ticked in reverse today.",
  "Beware of the invisible turtles.",
  "The tree laughed when I said hello.",
  "What does the snow whisper at night?",
  "Don't look directly at the jellyfish king.",
  "The doorknob forgot its manners.",
  "The chair is a master of riddles.",
  "Clouds are terrible at keeping secrets.",
  "The fish gave me life advice.",
  "The soup knows your destiny.",
  "I once traded riddles with a starfish.",
  "The ceiling fan told me a joke.",
  "The moon refused to share its diary.",
  "The rain sang me to sleep.",
  "Why did the comet giggle?",
  "Beware the envious umbrella.",
  "The carpet plans to take over the world.",
  "The pencil learned calligraphy last night.",
  "I taught a shadow to waltz.",
  "The jellyfish held a secret meeting.",
  "Do raindrops argue over who lands first?",
  "The stars wrote me a letter in Morse code.",
  "The curtains are whispering gossip.",
  "The cactus wore a scarf today.",
  "The piano forgot its melody.",
  "The bookshelf sighed in contentment.",
  "Beware of the laughing teapot.",
  "The broomstick dreams of flying solo.",
  "Your socks are conspiring against you.",
  "The clouds blushed at sunrise.",
  "Why is the ocean so quiet today?",
  "The mirror borrowed my smile.",
  "The toaster is writing a memoir.",
  "Rainbows hide their true colors.",
  "The clock hiccupped at noon.",
  "Do stars laugh at comets?",
  "The lamp hummed an ancient tune.",
  "Beware the broccoli conspiracy.",
  "The moon hummed a lullaby.",
  "Do fish count stars underwater?",
  "The chair told me a bedtime story.",
  "The umbrella confessed its fears.",
  "The dictionary forgot my name again.",
  "The door squeaked out a melody.",
  "Beware the plotting paperclips.",
  "The rain drew pictures on the window.",
  "Do shadows argue about shapes?",
  "The kettle practiced its high notes.",
  "The bookshelf taught me patience.",
  "Why did the chair sigh?",
  "The wind told me a secret path.",
  "The clock envies the calendar.",
  "The spoon danced with the fork.",
  "Your mirror lied to me.",
  "The clouds painted the sunset.",
  "Beware of the grumpy starfish.",
  "The moon practiced its winking.",
  "The coffee mug told me its dreams.",
  "The stars held a silent protest.",
  "The shadows debated geometry.",
  "The umbrella has a secret admirer.",
  "The rain whispered a prophecy.",
  "Do lamps miss the sun?",
  "The jellybeans are planning a party.",
  "Beware of the singing staircase.",
  "The clock practiced its ticking today.",
  "The teacup hummed in the cupboard.",
  "Do clouds envy rainbows?",
  "The toaster composed a symphony.",
  "The stars argued over constellations.",
  "The mirror practiced winking.",
  "The cactus studied philosophy.",
  "The wind composed a love letter.",
  "The jellyfish forgot how to swim.",
  "Do tables miss their chairs?",
  "The piano hummed its favorite tune.",
  "Beware of the mischievous doormat.",
  "The clock hummed at midnight.",
  "The rain tried to rhyme today.",
  "The stars practiced their twinkling.",
  "The clouds argued about shapes.",
  "The shadows danced at dusk.",
  "Do lamps envy fireflies?",
  "The umbrella told me a secret.",
  "The bookshelf shared its wisdom.",
  "Why did the clock laugh?",
  "The moon practiced its pirouettes.",
  "Beware of the humming fridge.",
  "The kettle whispered a tune.",
  "The doorknob told me a riddle.",
  "Do fish dream of flying?",
  "The pencil hummed a forgotten song.",
  "The clouds practiced their shading.",
  "The toaster hummed in agreement.",
  "The stars held a silent meeting.",
  "The mirror practiced smiling.",
  "The cactus danced at sunset.",
  "The wind hummed a lullaby.",
  "The jellybeans whispered secrets.",
  "Do tables miss their chairs?",
  "The piano forgot its favorite song.",
  "Beware of the suspicious teapot!",
  "Why there are no taurens in Tauren Mill?",
  "Why is Purple Lotus called purple if I can see it?",
  "I wonder where that fish has gone."
}

function AutoInvite.response( facade )
  local m = facade.api.math
  m.randomseed( facade.now() )

  local function random()
    ---@diagnostic disable-next-line: deprecated
    local index = m.random( 1, table.getn( responses ) )
    return responses[ index ]
  end

  return {
    random = random
  }
end
