
-- Hide Status Bar
display.setStatusBar(display.HiddenStatusBar)

-- Background
local bg = display.newImage('images/gameBg.png')
bg.x = display.contentCenterX
bg.y = display.contentCenterY

-- Title View
local titleBg
local playBtn
local systemBtn
local titleView
local backBtn

-- Score
local score
local ScoreTitle
local scoreView

-- Worms
local e1, e2, e3, e4, e5, e6 ,e7, e8 ,e9 ,e10 ,e11 ,e12
local normalPic
local normalRand
local hardPic
local hardRand
local worms
local lastWorm = {}

-- Load Sound
local hit = audio.loadSound('decision15.mp3')
local hitMiss = audio.loadSound('ko1.mp3')

-- Variables
local timerSource
local wormsHit = 0

-- Setting
local level = 1
local systemText
local soundText
local levelText
local systemView
local sound = 1
local on
local off
local easy, normal, hard

-- Functions
local Main = {}
local backTop = {}
local startButtonListeners = {}
local systemsetting = {}
local showGameView = {}
local levelSelectEasy = {}
local levelSelectNormal = {}
local levelSelectHard = {}
local prepareWormsEasy = {}
local prepareWormsNormal = {}
local prepareWormsHard = {}
local startTimer = {}
local showWorm = {}
local popOut = {}
local wormHit = {}
local wormMiss = {}
local wormMissHard = {}
local soundOn = {}
local soundOff = {}
local alert = {}
local restart = {}

-- timer
local M, S, ss= 0, 40, 0
local timeLabel = display.newText("00:00.00",100,34,native.systemFontBold,40)
local scoreNow = display.newText("目前分數:0", 100, -10, native.systemFont, 25)
scoreNow:setFillColor(1, 1, 1)

-- Main Function
function Main()
  titleBg = display.newImage('images/titleBg.png')
  titleBg.x = display.contentCenterX
  titleBg.y = display.contentCenterY

	playBtn = display.newImage('images/start.png')
	playBtn.x = 200
  playBtn.y = 370

  systemBtn = display.newImage('images/system.png')
  systemBtn.x = 290
  systemBtn.y = 10
  
	titleView = display.newGroup(titleBg, playBtn, systemBtn)
	startButtonListeners('add')
  wormsHit = 0
end

-- startButton
function startButtonListeners(action)
	if(action == 'add') then
		playBtn:addEventListener('tap', showGameView)
    systemBtn:addEventListener('tap', systemsetting)
	else
		playBtn:removeEventListener('tap', showGameView)
    systemBtn:removeEventListener('tap', systemsetting)
	end
end

-- showGameView
function showGameView:tap(e)
  myTimerStartToGo=timer.performWithDelay(1, onTickCount,0)
	transition.to(titleView, {time = 500, x = -titleView.height, 
	                           onComplete = function() 
	                           startButtonListeners('rmv') 
	                           display.remove(titleView) 
	                           titleView = nil 
	                           end})

	score = display.newText('0' , 385, 30,
	                                native.systemFontBold, 16)
	score:setTextColor(1, 1, 1)
  if (level == 1) then
    prepareWormsEasy()
  elseif (level == 2) then
    prepareWormsNormal()
  elseif (level == 3) then
    prepareWormsHard()
  end
end

-- systemsetting
function systemsetting()
	display.remove(titleView)
  titleBg = display.newImage('images/titleBg.png')
  titleBg.x = display.contentCenterX
  titleBg.y = display.contentCenterY
  systemText = display.newText( "設定", 120, 10, native.systemFont, 30 )
  systemText:setFillColor( 0.9, 0.9, 1 )
  
  soundText = display.newText("音效:", 50, 70, native.systemFont, 20)
  on = display.newText("開", 110, 70, native.systemFont, 20)
  off = display.newText("關", 170, 70, native.systemFont, 20)
  if (sound == 1) then
    off:setFillColor( 1, 1, 1 )
  else
    on:setFillColor( 1, 1, 1 )
  end
  on:addEventListener('tap', soundOn)
  off:addEventListener('tap', soundOff)
  
  soundText:setFillColor( 1, 1, 1 )
  levelText = display.newText("難度:", 50, 100, native.systemFont, 20)
  levelText:setFillColor( 1, 1, 1 )
  easy = display.newText("簡單", 110, 100, native.systemFont, 20)
  normal = display.newText("普通", 170, 100, native.systemFont, 20)
  hard = display.newText("困難", 230, 100, native.systemFont, 20)
  if (level == 1) then
    normal:setFillColor( 1, 1, 1 )
    hard:setFillColor( 1, 1, 1 )
  elseif (level == 2) then
    easy:setFillColor( 1, 1, 1 )
    hard:setFillColor( 1, 1, 1 )
  elseif (level == 3) then
    easy:setFillColor( 1, 1, 1 )
    normal:setFillColor(1, 1, 1)
  end
  easy:addEventListener('tap', levelSelectEasy)
  normal:addEventListener('tap', levelSelectNormal)
  hard:addEventListener('tap', levelSelectHard)
  
  backBtn = display.newImage('images/back.png')
  backBtn.x = 250
  backBtn.y = 480
  backBtn:addEventListener('tap', backTop)
  
  systemView = display.newGroup(titleBg, systemText, backBtn, soundText, levelText, easy, normal, hard, on, off)
end

--levelSelect
function levelSelectEasy()
  level = 1
  display.remove(systemView)
  systemsetting()
end
function levelSelectNormal()
  level = 2
  display.remove(systemView)
  systemsetting()
end
function levelSelectHard()
  level = 3
  display.remove(systemView)
  systemsetting()
end

--soundSelect
function soundOn()
  sound = 1
  display.remove(systemView)
  systemsetting()
end
function soundOff()
  sound = 0
  display.remove(systemView)
  systemsetting()
end

-- Prepare worms
function prepareWormsEasy()
	e1 = display.newImage( "images/地鼠.png",200,90)
  e2 = display.newImage( "images/地鼠.png",220,180 )
  e3 = display.newImage( "images/地鼠.png",200,265)
  e4 = display.newImage( "images/地鼠.png",98,90)
  e5 = display.newImage( "images/地鼠.png",119,180)
  e6 = display.newImage( "images/地鼠.png",99,265 )
  e7 = display.newImage( "images/地鼠.png",119,353 )
  e8 = display.newImage( "images/地鼠.png",13,353 )
  e9 = display.newImage( "images/地鼠.png",-5,265)
  e10 = display.newImage( "images/地鼠.png",-5,90)
  e11 = display.newImage( "images/地鼠.png",13,178)
  e12 = display.newImage( "images/地鼠.png",220,353 )
	worms = display.newGroup(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12)
	for i = 1, worms.numChildren do
		worms[i]:addEventListener('tap', wormHit)
		worms[i].isVisible = false
	end
	startTimer()
end

function prepareWormsNormal()
	e1 = display.newImage( "images/地鼠.png",200,90)
  e2 = display.newImage( "images/地鼠.png",220,180 )
  e3 = display.newImage( "images/地鼠.png",200,265)
  e4 = display.newImage( "images/地鼠.png",98,90)
  e5 = display.newImage( "images/地鼠.png",119,180)
  e6 = display.newImage( "images/地鼠.png",13,178 )
  e7 = display.newImage( "images/地鼠.png",119,353 )
  e8 = display.newImage( "images/地鼠3.png",13,353 )
  e9 = display.newImage( "images/地鼠3.png",-5,265)
  e10 = display.newImage( "images/地鼠3.png",-5,90)
  e11 = display.newImage( "images/地鼠3.png",99,265)
  e12 = display.newImage( "images/地鼠3.png",220,353 )
	worms = display.newGroup(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12)
	for i = 1, 7 do
		worms[i]:addEventListener('tap', wormHit)
		worms[i].isVisible = false
	end
  for i = 8, 12 do
		worms[i]:addEventListener('tap', wormMiss)
		worms[i].isVisible = false
	end
	startTimer()
end

function prepareWormsHard()
	e1 = display.newImage( "images/地鼠.png",200,90)
  e2 = display.newImage( "images/地鼠.png",220,180 )
  e3 = display.newImage( "images/地鼠.png",-5,90)
  e4 = display.newImage( "images/地鼠.png",220,353)
  e5 = display.newImage( "images/地鼠.png",119,180)
  e6 = display.newImage( "images/地鼠.png",99,265 )
  e7 = display.newImage( "images/地鼠.png",119,353 )
  e8 = display.newImage( "images/地鼠2.png",13,353 )
  e9 = display.newImage( "images/地鼠2.png",-5,265)
  e10 = display.newImage( "images/地鼠2.png",200,265)
  e11 = display.newImage( "images/地鼠2.png",13,178)
  e12 = display.newImage( "images/地鼠2.png",98,90 )
	worms = display.newGroup(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12)
	for i = 1, worms.numChildren do
		worms[i]:addEventListener('tap', wormHit)
		worms[i].isVisible = false
	end
  for i = 8, 12 do
		worms[i]:addEventListener('tap', wormMissHard)
		worms[i].isVisible = false
	end
	startTimer()
end

function startTimer()
  randomTime = math.random(800,1400)
  print (randomTime)
	timerSource = timer.performWithDelay(randomTime , showWorm, 0)
end
function showWorm(e)
	if(S == 0 ) then
    timer.cancel(myTimerStartToGo)
		alert()
	else
		lastWorm.isVisible = false
		local randomHole = math.floor(math.random() * 12) + 1
		lastWorm = worms[randomHole]
		lastWorm:setReferencePoint(display.BottomCenterReferencePoint)
		lastWorm.yScale = 0.1
		lastWorm.isVisible = true
		Runtime:addEventListener('enterFrame', popOut)
	end
end

-- popOut
function popOut(e)
	lastWorm.yScale = lastWorm.yScale + 0.2
		if(lastWorm.yScale >= 1) then
		Runtime:removeEventListener('enterFrame', popOut)
	end
end
-- Worm Hit
function wormHit()
  if (sound == 1) then
    audio.play(hit)
  end
	wormsHit = wormsHit + 1
  scoreNow.text = "目前分數:" ..wormsHit *2
	lastWorm.isVisible = false
end
function wormMiss()
  if (sound == 1) then
    audio.play(hit)
  end
	wormsHit = wormsHit - 1
  scoreNow.text = "目前分數:" ..wormsHit *2
	lastWorm.isVisible = false
end
function wormMissHard()
	if (sound == 1) then
    audio.play(hitMiss)
  end
	wormsHit = wormsHit - 2
  scoreNow.text = "目前分數:" ..wormsHit *2
	lastWorm.isVisible = false
end

-- alert
function alert()
  alertView = display.newGroup()
  timer.cancel(timerSource)
  lastWorm.isVisible = false
  alertBox = display.newImage('images/alertBg.png')
  alertBox:setReferencePoint(display.CenterReferencePoint)
  alertBox.x = 158
  alertBox.y = 110
  alertView:insert(alertBox)
  transition.from(alertBox, {time = 300, xScale = 0.3, yScale = 0.3})
  alertScore = display.newText(wormsHit*2, 130, 100, 
                                            native.systemFontBold, 50)
  alertScore:setTextColor(104, 33, 20)
  alertView:insert(alertScore)
  alertBox:addEventListener('tap', restart)
  S=40
    ss=0
end

-- back
function backTop()
  display.remove(systemView)
  Main()
end

-- ReStart
function restart()
  display.remove(alertView)
  display.remove(score)
  display.remove(worms)
  scoreNow.text = "目前分數:0"
  Main()
end

timeLabel:setTextColor(255/255, 0, 0)
timeLabel.x = 167
timeLabel.y = 72

-- 計數函式

onTickCount = function(event)
    ss = ss - 3.15     --3.15 為計時器準時調整值(百分秒每次計時觸發增加值)
    if math.round(ss) <= 3.15 then
        ss = 99
        S = S - 1        -- 秒
        if S == 0 and M ~= 0 then
            S = 60
            M = M - 1    -- 分
        end
    end
    
      -- 顯示時間 
    myTimeString = DoubleNum(M) .. ":" .. DoubleNum(S) .. "." .. DoubleNum(math.round(ss))
    timeLabel.text = myTimeString
    
end


-- 將參數N改為2位數字
DoubleNum = function(N)
    if string.len(N) == 1 then
       N = "0" .. N
    end
    return N

end 

Main()

--
