DELETE FROM `quest_template` WHERE `Id`=36706;
INSERT INTO `quest_template` (`Id`, `PrevQuestId`, `NextQuestId`, `Title`, `Details`) VALUES (36706, 34775, 36707, 'Ashran Appearance', 'Our base on Ashran is almost complete, commander.$b$bIt would be a huge show of support if you could make a trip out there and put your stamp of approval on their staging area.$b$bI can arrange a flight if you are interested.');
DELETE FROM `quest_template` WHERE `Id`=36707;
INSERT INTO `quest_template` (`Id`, `PrevQuestId`, `NextQuestId`, `Title`, `Details`) VALUES (36707, 36706, 36708, 'Warspear Welcome', 'Lieutenant Kragil said you might be showing up.$b$bI\'ve been ordered to take you to the inn.');
DELETE FROM `quest_template` WHERE `Id`=36708;
INSERT INTO `quest_template` (`Id`, `PrevQuestId`, `NextQuestId`, `Title`, `Details`) VALUES (36708, 36707, 36709, 'Inspiring Ashran', 'I hope you will find our facilities to be up to your high standards.$b$bThis inn is run by Narnin Dawnglow, in my opinion this is the best place to hearth in Draenor.$b$bWe have new recruits coming through the portal daily. In fact one of out latest recruits, Zarjhin, just came through the portal today.$b$bIf you are looking for weapons or armor Beska Redtusk will be happy to help.');
DELETE FROM `quest_template` WHERE `Id`=36708;
INSERT INTO `quest_template` (`Id`, `PrevQuestId`, `NextQuestId`, `Title`, `Details`) VALUES (36708, 36707, 36709, 'Inspiring Ashran', 'I hope you will find our facilities to be up to your high standards.$b$bThis inn is run by Narnin Dawnglow, in my opinion this is the best place to hearth in Draenor.$b$bWe have new recruits coming through the portal daily. In fact one of out latest recruits, Zarjhin, just came through the portal today.$b$bIf you are looking for weapons or armor Beska Redtusk will be happy to help.');
DELETE FROM `quest_template` WHERE `Id`=36709;
INSERT INTO `quest_template` (`Id`, `PrevQuestId`, `NextQuestId`, `Title`, `Details`) VALUES (36709, 36708, 35243, 'Burning Beauty', 'Before you go, there is someone you should meet.$b$bShe might set some of your stuff on fire, but I believe she\'s the best mage this side of Draenor.$b$bShe belongs on the front lines with you, commander.');
DELETE FROM `quest_template` WHERE `Id`=35243;
INSERT INTO `quest_template` (`Id`, `PrevQuestId`, `NextQuestId`, `Title`, `Details`) VALUES (35243, 36709, 0, 'The Dark Lady\'s Gift', 'I was bidden to find my way to you, and to swear my service. Whatever you need of me, I will offer. I take a particular pleasure in turning things to ashes.$B$BThe dark lady sends her regards.');
