//
//  Activity.swift
//  tivy
//
//  Created by Isaac Schiffler on 4/22/23.
//

import Foundation

struct Activity: Identifiable {
    let id: UUID
    var title: String
    var image: String
    var description: String
    var effort: Double
    var time: Double
    var cost: Double
    var physical: Double
    var isFav: Bool
    
    init(id: UUID = UUID(), title: String, image: String, description: String, effort: Double, time: Double, cost: Double, physical: Double, isFav: Bool) {
        self.id = id
        self.title = title
        self.image = image
        self.description = description
        self.effort = effort
        self.time = time
        self.cost = cost
        self.physical = physical
        self.isFav = isFav
    }
}

extension Activity {
    static let sampleData: [Activity] =
    [
        Activity(title: "Camping Trip",
                 image: "CampingFriends",
                 description: "Plan a camping trip with your friends for a weekend. Bring lots of booze and get prepared for an absolute bender. It should be in the most white trash area possible. The ratio of racist to degenerates to normal people should be 100:100:1. Also, Parker should turn into Fernando at least once. Again to emphasize: booze if a must.",
                 effort: 1,
                 time: 1,
                 cost: 0.8,
                 physical: 0.3,
                 isFav: true),
        Activity(title: "Wakesurfing",
                 image: "Surf",
                 description: "Go get surfing on the lake. You're gonna need either Brynna's or Isaac's boat though... Also its much better when the wind is <10 MPH.",
                 effort: 0.6,
                 time: 0.3,
                 cost: 0.1,
                 physical: 0.3,
                 isFav: false),
        Activity(title: "Backpacking in Yellowstone",
                 image: "YS",
                 description: "This is going to be a very difficult trip to plan but it is going to be well worth it. You should set aside about 5 days for this trip. Also getting a reservation helps a lot, otherwise you can take your chances at walk-up campsites. There is lots of required camping equipment you'll need as well. Although it will be tough to get going, it will be one of the most fun experiences of your life.",
                 effort: 1,
                 time: 1,
                 cost: 0.99,
                 physical: 1,
                 isFav: true),
        Activity(title: "Go to a Waterfall",
                 image: "Waterfall",
                 description: "Go bask in the glory of a cascading watefall. I don't remember where this one was but the Minnehaha Falls is also pretty sick I think. Super fun time to explore and it is a quick morning/afternoon trip. Probably bring a swimsuit and a pair of shoes that you are fine getting wet.",
                 effort: 0.6,
                 time: 0.6,
                 cost: 0.8,
                 physical: 0.4,
                 isFav: true),
        Activity(title: "Explore the Badlands",
                 image: "Badlands",
                 description: "This is going to be quite the trip but will be fairly time consuming. The environment and sights are immaculate. Climbing around the rock structures is a blast and the exploring is amazing. Being at the Badlands for sunrise or sunset is an unforgettable experience. The potential for rolling large rocks down hills is a major bonus, too. This is definitely a tough one to get planned around work schedules, but is an unforgettable experience. (You can also stop here on the way to/from Yellowstone.)",
                 effort: 1,
                 time: 1,
                 cost: 0.6,
                 physical: 0.3,
                 isFav: true),
        Activity(title: "Pristine Ice Skating",
                 image: "Ice",
                 description: "Going ice skating on a perfectly smooth lake with no snow is one of the most satisfying experiences ever. However, the opportunity usually only arises for a week every couple of years. Definitely a must to if you encounter the opportunity.",
                 effort: 0.4,
                 time: 0.2,
                 cost: 0,
                 physical: 0.5,
                 isFav: false),
        Activity(title: "Go out on the Boat",
                 image: "boat",
                 description: "This one is pretty self-explanatory and easy. Just hit the lake and chill (maybe booze too?!?!). Gotta get either Isaac's, Brynna's, Jack's, or Hadleigh's boat (but let's be honest its probably gonna be Isaac's). Can be done just for a couple hours so very easy and can always hide from the wind so any time the suns out its a good option.",
                 effort: 0.2,
                 time: 0.3,
                 cost: 0,
                 physical: 0.1,
                 isFav: false),
        Activity(title: "Bars at the U",
                 image: "theU",
                 description: "I mean fuck idk if we have ever ripped the bars at the U with all of us and not had a wicked time. There have been some iconic moments that have come from that place... Charlie breaking his hip... Ben falling off Kaitlyn's roof twice on video... Connor's 5 minute piss while we were on the lightrail... Hadleigh evaporating into thin air (a frat house)... Good times. Never goes wrong. Plus everyone has apartments we can stay at with no parents!!! No rules!!! We can do anything we want!!!",
                 effort: 0.65,
                 time: 0.7,
                 cost: 0.7,
                 physical: 0.3,
                 isFav: false),
        Activity(title: "Bags Tourney: INCOMPLETE",
                 image: "bags",
                 description: "Bags Tourney!!! (darty in disguise of a backyard sport) Should be a good time though. Sun should be shining and everyone should get properly lubricated (with beer) within a couple of hours of playing bags. Chill rating: hella chill.",
                 effort: 0.69,
                 time: 0.65,
                 cost: 0,
                 physical: 0.35,
                 isFav: false),
        Activity(title: "Casino Night: INCOMPLETE",
                 image: "poker",
                 description: "This is going to be a very high-class big money big baller night. Dressing well is a must and anyone under-dressed will be banished. Ideally, there will be a poker table and Blackjack table running. I would say buy-in for poker should be $100 (you're not gonna waste $100 unless you plan to lose it all). Some nice drinks should also be served (Bartender Ben?). Could maybe even hire a sibling to dress up and be dealer...",
                 effort: 0.5,
                 time: 0.67,
                 cost: 0.3,
                 physical: 0,
                 isFav: false),
        Activity(title: "Backpacking in Glacier: INCOMPLETE",
                 image: "glacier",
                 description: "Basically same as Yellowstone but at Glacier National Park. Should be a fucking wicked trip.",
                 effort: 1,
                 time: 1,
                 cost: 1,
                 physical: 1,
                 isFav: true),
        Activity(title: "Cliff Jumping: INCOMPLETE",
                 image: "cliffjumping",
                 description: "Go cliff jumping at the quarries. A solid day trip to get the adrenaline pumping.",
                 effort: 0.65,
                 time: 0.6,
                 cost: 0.2,
                 physical: 0.6,
                 isFav: true),
        Activity(title: "Twins or Saints Game: INCOMPLETE",
                 image: "saints",
                 description: "This one could actually be stupid fun. We could all get some fairly cheap Twin's tickets and go watch a night game and booze a wee bit. Would suck to be the sober driver for this one though. Could be a pretty good time though.",
                 effort: 0.7,
                 time: 0.7,
                 cost: 0.4,
                 physical: 0.2,
                 isFav: true),
        Activity(title: "Sky Diving: INCOMPLETE",
                 image: "skydive",
                 description: "Pretty obvious what this one will entail. According to this one website, it's like $230 on a weekday. Suggested by Hadleigh.",
                 effort: 0.85,
                 time: 0.8,
                 cost: 0.9,
                 physical: 0.9,
                 isFav: false),
        Activity(title: "Live Comedy: INCOMPLETE",
                 image: "comedy",
                 description: "IDK a whole lot about this one but Ben probably has some solid info. I think there are comedy clubs where you just kinda go there and get food and drinks while you listen to live comedy. Could be pretty cool. Would only take a few hours of a night. Suggested by Ben",
                 effort: 0.3,
                 time: 0.45,
                 cost: 0.5,
                 physical: 0,
                 isFav: false),
        Activity(title: "Live Comedy, but it's Ben: INCOMPLETE",
                 image: "ben",
                 description: "Same as Live Comedy, but we'd be watching Ben do it! This would actually be pretty sick. Must-do if Ben's going on stage or even if he just does it in one of our basements lol. Suggested by Ben.",
                 effort: 0.3,
                 time: 0.45,
                 cost: 0.5,
                 physical: 0,
                 isFav: false),
        Activity(title: "Drive to a Random State: INCOMPLETE",
                 image: "midwest",
                 description: "Make a little 1-2 day trip literally just driving to a random state and finding something fun to do. We could camp there, sleep in cars, find a hostel, or get hotel/motel rooms. Would definitely be a good time. Tough to organize with work but probably worth it to give it a shot. Probably just roll a die and pick the state based on the result. (1-ND 2-SD 3-WIS 4-IOWA (god i hope not) 5-MICH 6-ILL (the bean??)) Can also maybe throw Nebraska (barf) in the lineup. Suggested by Ben.",
                 effort: 0.9,
                 time: 0.9,
                 cost: 0.6,
                 physical: 0,
                 isFav: false),
        Activity(title: "Just Chill...: INCOMPLETE",
                 image: "hmm",
                 description: "\"Shrooms\" is the text I got from Ben. I'm guessing we would go to some cool nature place like the arboretum or on the lake or a waterfall for it. I am honestly down to try shrooms I think (as long as they're well sourced (Erik?) and approved by Jack and his shroom book). Could be quite the experience. Suggested by Ben.",
                 effort: 0.5,
                 time: 0.7,
                 cost: 0.55,
                 physical: 0,
                 isFav: false),
        Activity(title: "Music Festival: INCOMPLETE",
                 image: "winstock",
                 description: "Attend a music festival. Options are: Winstock June 16-17, ~$150 | We Fest August 3-5, ~$180 | Lakefront Music Fest July 14-15, ~$70/day. Would definitely be pretty cool but on the pricier side for the bigger events. Suggested by Jack.",
                 effort: 0.75,
                 time: 0.75,
                 cost: 0.85,
                 physical: 0,
                 isFav: false),
        Activity(title: "Set off fireworks: INCOMPLETE-ish",
                 image: "fireworks",
                 description: "Honestly just get Erik to put on a firwork show lmao.",
                 effort: 0.2,
                 time: 0.2,
                 cost: 0.3,
                 physical: 0,
                 isFav: false),
        Activity(title: "Mystic: INCOMPLETE-ish",
                 image: "mystic",
                 description: "Just head on over to Mystic and start fucking gambling!!! God I love gambling. I think we should get enough to conquer a table of blackjack so its just us and the dealer and it's not embarrassing when we fuck up. And play roulette obviously (and charlie win another $5k??? Suggested by Jack.",
                 effort: 0.55,
                 time: 0.45,
                 cost: 0.4,
                 physical: 0,
                 isFav: false),
        Activity(title: "Party with Grade Below: INCOMPLETE",
                 image: "joe",
                 description: "Party with the grade below us but actually the fun ones... No need to name which I am talking about. But let's actually party with Beefs crowd. Can't believe we haven't done that already... Suggested by Jack.",
                 effort: 0.35,
                 time: 0.35,
                 cost: 0,
                 physical: 0,
                 isFav: false),
        Activity(title: "Canada: INCOMPLETE",
                 image: "canada",
                 description: "Fuck idk but I feel like it would be pretty sick. Pretty long drive though... Unlikely but potential. Also drinking age is max 19 anywhere in Canada...",
                 effort: 1,
                 time: 1,
                 cost: 0.6,
                 physical: 0.4,
                 isFav: false),
        Activity(title: "Play Dye: INCOMPLETE-ish",
                 image: "dye",
                 description: "Basically just have a darty but also play dye. I still have the board under my deck from last year so might as well use it. Also, we should paint it or something.",
                 effort: 0.5,
                 time: 0.5,
                 cost: 0,
                 physical: 0.5,
                 isFav: false),
        Activity(title: "Paint Dye Table: INCOMPLETE",
                 image: "paint_dye",
                 description: "I am going to leave this one up to someone with far superior artistic techniques so ya. Maybe I'll try to contribute and fill in some lines or something. Could be pretty cool though if it turns out.",
                 effort: 0.5,
                 time: 0.3,
                 cost: 0.2,
                 physical: 0,
                 isFav: false),
        Activity(title: "Camp on the Island: INCOMPLETE",
                 image: "coney",
                 description: "I seriously do not know how we still have not done this. It would take a tiny bit of preperation but at the same time not really. We could get like 5 pizzas and cruise out there with some firewood and chairs. We could set up tents to sleep in or literally just sleep in enos. We could drop off all major supplies like chairs and firewood from the boat and then use the jetski to get the last stuff out. It will be a lot easier than it seems and I think is a must-complete task before exiting good ole Waconia for the real world.",
                 effort: 0.7,
                 time: 0.8,
                 cost: 0.4,
                 physical: 0.3,
                 isFav: false),
        Activity(title: "Watch Paxton Sleep: INCOMPLETE",
                 image: "paxton",
                 description: "Ya know I've just always really wanted to hang out with everyone while watching Paxton sleep. Seems like quite the time. Certified must complete.",
                 effort: 1,
                 time: 1,
                 cost: 1,
                 physical: 1,
                 isFav: false),
        Activity(title: "Group Golf Scramble: INCOMPLETE",
                 image: "scramble",
                 description: "This would actually be insanely fun. We could split up into groups of 3-4 and do a golf scramble tourney at one of the cheaper courses. Everyone could booze a little and have a good time sucking at golf. People that don't have clubs could pretty easily find someone to borrow a set from. Maybe if we split teams evenly we could put some money on it??? (I have a gambling addiction)",
                 effort: 0.75,
                 time: 0.7,
                 cost: 0.6,
                 physical: 0.5,
                 isFav: false),
        Activity(title: "Slip & Slide: INCOMPLETE-ish",
                 image: "slipslide",
                 description: "Not actually incomplete because we do it at Brynna's for the 4th but I don't have any pictures of it. Brynna can we do it again? It's so fucking lit.",
                 effort: 0.65,
                 time: 0.3,
                 cost: 0.1,
                 physical: 0.4,
                 isFav: false),
        Activity(title: "College Friends Darty: INCOMPLETE",
                 image: "college",
                 description: "We darty... but we also invite everyones college friends in MN to join (Kate's roommate?) Would be pretty sick getting everyone's school friends together so we (I) can meet them all (Kate's roommate)",
                 effort: 0.3,
                 time: 0.5,
                 cost: 0,
                 physical: 0,
                 isFav: false),
        Activity(title: "Airsoft War: INCOMPLETE",
                 image: "airsoft",
                 description: "I'm guessing none of the girls will be ineterested in joining but feel free. Anyway, we have an airsoft war at a sick spot (maybe on the island?). But to make it way more fun, we have to all not be pussies and not camp so its full on war. I want carnage. Maybe 20 second respawns to keep the game going and play to like 10 kills or something",
                 effort: 0.6,
                 time: 0.4,
                 cost: 0,
                 physical: 0.75,
                 isFav: true),
        Activity(title: "Hot Dog Eating Contest: INCOMPLETE",
                 image: "hotdog",
                 description: "This would be so fucking funny. We could do it at one of our darties and it would actually be so lit. Maybe get/make a trophy for the winner. I volunteer to contend and will tak on any foe that dares. So proud of myself for thinking of this one.",
                 effort: 0.65,
                 time: 0.3,
                 cost: 0.1,
                 physical: 1,
                 isFav: false),
        Activity(title: "Everyone Goes to Work!",
                 image: "work",
                 description: "Fuck ya this is lit!! I love work!!",
                 effort: 0,
                 time: 0,
                 cost: 0,
                 physical: 0,
                 isFav: false),
        Activity(title: "Adderal Poker: INCOMPLETE",
                 image: "add_poker",
                 description: "All the boys take adderal (supplied by Jack?) and rip a legit 4 hour session of poker. It would be so fucking sick. We would all be so locked in and the play would be nuts. We gotta do this. Maybe if we're feeling crazy mix the adderal with a little booze.",
                 effort: 0.65,
                 time: 0.5,
                 cost: 0.25,
                 physical: 0,
                 isFav: false),
        Activity(title: "Pickleball: INCOMPLETE",
                 image: "pball",
                 description: "Go play pickleball at the tennis courts either at the T-dock or at the high school. Only need like 4 people to do this so it's easy and fun.",
                 effort: 0.6,
                 time: 0.4,
                 cost: 0,
                 physical: 0.75,
                 isFav: false),
        Activity(title: "Volleyball: INCOMPLETE-ish??",
                 image: "vball",
                 description: "Go play volleyball at someone's house or at the beach. Only need like 4 or 6 people. Always fun.",
                 effort: 0.5,
                 time: 0.3,
                 cost: 0,
                 physical: 0.75,
                 isFav: false),
        Activity(title: "TopGolf: INCOMPLETE",
                 image: "topgolf",
                 description: "Hit top golf. It's usually pretty fun I think and there are games incorporated into it. Not super expensive either I don't think. Looks like $40-$60 for an hour at a bay.",
                 effort: 0.68,
                 time: 0.45,
                 cost: 0.55,
                 physical: 0.4,
                 isFav: false),
        Activity(title: "Watch Curling: INCOMPLETE",
                 image: "curling",
                 description: "Go to the Chaska restaurant with the curling center attached and get some food and watch curling. Good if we're wondering where to go for dinner or something.",
                 effort: 0.3,
                 time: 0.3,
                 cost: 0.4,
                 physical: 0,
                 isFav: false),
        Activity(title: "Cantebury: INCOMPLETE",
                 image: "cantebury",
                 description: "I know we talked about doing this one last year but never got around to it but we so should this year. We can all go and gamble (I still love gambling). It would be such a good time. There is horse racing Wednesday, Thursday, Saturday, and Sunday from July 12th to August 20th. Tickets are very cheap, like $10 or less I think.",
                 effort: 0.75,
                 time: 0.6,
                 cost: 0.25,
                 physical: 0.1,
                 isFav: true),
        Activity(title: "Group Minecraft: INCOMPLETE",
                 image: "minecraft",
                 description: "We get a massive realm going that everyone joins. We can split up to make teams or something. Would be so gas.",
                 effort: 0.5,
                 time: 0.5,
                 cost: 0,
                 physical: 1,
                 isFav: false),
        Activity(title: "State Fair: INCOMPLETE",
                 image: "stateFair",
                 description: "We can all just head on over to the State Fair and roam around. I have never been but I have heard a lot of good things. Allegedly it's better to go later in the night so it's cooler and less crowded. My sister also said they used their fakes at it and they worked so...",
                 effort:0.65,
                 time: 0.65,
                 cost: 0.6,
                 physical: 0.4,
                 isFav: false),
        Activity(title: "Isaac Beer/Milk Mile: INCOMPLETE",
                 image: "beermile",
                 description: "Ah fuck. This one should be fun... for some. Nonetheless, I will persevere and absolutely demolish expectations. Beer, milk, and the track alike will fear me on this day, for nothing shall stand in my path to glory. I will PREVAIL! But ya, it'll be tough.",
                 effort: 1,
                 time: 0.2,
                 cost: 0,
                 physical: 1,
                 isFav: false),
        Activity(title: "Sunset Picnic: INCOMPLETE",
                 image: "sunset_waconia",
                 description: "This is a pretty lax activity. Basically it is just hanging out and watching the sunset. Ideal spot would probably be on that hill by the newest boat launch on the East side of the lake. This should give a solid view of the sunset over the lake.",
                 effort: 0.3,
                 time: 0.2,
                 cost: 0.3,
                 physical: 0,
                 isFav: false),
        Activity(title: "Tubing",
                 image: "tubing",
                 description: "Go out tubing on the lake. Honestly, tubing is never not fun. Will need to find someone with a tube, though...",
                 effort: 0.7,
                 time: 0.3,
                 cost: 0.1,
                 physical: 0.65,
                 isFav: false),
        Activity(title: "Nerf War: INCOMPLETE",
                image: "nerf",
                 description: "Have a nerf war around a neighborhood or just around someones house. Would definitely be fun without the risk/pain involved with airsoft guns.",
                 effort: 0.5,
                 time: 0.3,
                 cost: 0,
                 physical: 0.5,
                 isFav: false),
        Activity(title: "Tennis",
                 image: "tennis",
                 description: "Go hit some yellow balls with rackets. Pretty easy and lots of fun. Could play at high school or by the T-dock (great view).",
                 effort: 0.3,
                 time: 0.35,
                 cost: 0,
                 physical: 0.7,
                 isFav: false),
        Activity(title: "Bonfire",
                 image: "bonfire",
                 description: "Very casual activity. Can crack some brews and enjoy a beautiful summer night. Great night activity.",
                 effort: 0.3,
                 time: 0.35,
                 cost: 0,
                 physical: 0,
                 isFav: false),
        Activity(title: "Take a Walk",
                 image: "walk",
                 description: "Just go for a casual walk on some trail. There are a lot of good ones around the lake or could just find some random woods to walk through. Definitely good for a nice day. Can take the dogs with as well!",
                 effort: 0.2,
                 time: 0.3,
                 cost: 0,
                 physical: 0.45,
                 isFav: false),
        Activity(title: "Take a Hike",
                 image: "hike",
                 description: "Go take a legit hike at some school spot. Not totally sure what's around for hiking spots but hopping on AllTrails could reveal some solid spots.",
                 effort: 0.4,
                 time: 0.4,
                 cost: 0,
                 physical: 0.65,
                 isFav: false),
        Activity(title: "Luge in Lutsen: INCOMPLETE",
                 image: "luge",
                 description: "This would be crazy fun but definitely pretty far away. If we make a trip up North, this should definitely be involved. Super cool.",
                 effort: 0.7,
                 time: 0.8,
                 cost: 0.4,
                 physical: 0.5,
                 isFav: false),
        Activity(title: "Fishing",
                 image: "fish",
                 description: "Either just go fishing of someones dock or take out someone's boat to catch some hogs. There truly is nothing like reelin in a nice bass.",
                 effort: 0.3,
                 time: 0.3,
                 cost: 0,
                 physical: 0.2,
                 isFav: false),
        Activity(title: "Roller Skating: INCOMPLETE",
                 image: "roller_skate",
                 description: "Get some roller blades and starting shredding down a walking path. Don't think I have roller skates personally but would definitely go if I could source some.",
                 effort: 0.4,
                 time: 0.3,
                 cost: 0,
                 physical: 0.55,
                 isFav: false),
        Activity(title: "Minneopa State Park: INCOMPLETE",
                 image: "minneopa",
                 description: "I have never been here or even heard of it until recently. It looks super sick and has a cool waterfall and bison! It is located in Mankato so it would be perfect for a solid day trip. Definitely wanna do this at some point.",
                 effort: 0.6,
                 time: 0.65,
                 cost: 0.3,
                 physical: 0.3,
                 isFav: false),
        Activity(title: "Frisbee Golf",
                 image: "frolf",
                 description: "Let's go rip a wee bit of frolf eh? Actually is way more fun than I expected. Can even up the stakes and gamble on it a bit? Good course at Crown or in Watertown I think.",
                 effort: 0.4,
                 time: 0.4,
                 cost: 0,
                 physical: 0.5,
                 isFav: false),
        Activity(title: "Trivia Night: INCOMPLETE",
                 image: "trivia",
                 description: "We could all come up with like 5-10 trivia questions for this. Everyone can be sippin on some drinks and we could split up into teams or something. Suggested by Jack I think.",
                 effort: 0.4,
                 time: 0.4,
                 cost: 0,
                 physical: 0,
                 isFav: false)
    ]
}
