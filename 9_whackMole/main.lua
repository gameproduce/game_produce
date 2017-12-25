
-- Hide Status Bar
display.setStatusBar(display.HiddenStatusBar)

-- Background
local bg = display.newImage('images/gameBg.png')
bg.x = display.contentCenterX
bg.y = display.contentCenterY

-- Title View
local titleBg
local playBtn
local titleView

-- Score
local score

-- Worms
local w1, w2, w3, w4, w5, w6 ,w7, w8 ,w9 ,w10 ,w11 ,w12
local worms
local lastWorm = {}

-- Load Sound
local hit = audio.loadSound('decision15.mp3')

-- Variables
local timerSource
local wormsHit = 0

-- Functions
local Main = {}
local startButtonListeners = {}
local showGameView = {}
local prepareWorms = {}
local startTimer = {}
local showWorm = {}
local popOut = {}
local wormHit = {}
local alert = {}
local restart = {}

-- timer
local M, S, ss= 0, 40, 0
local timeLabel = display.newText("00:00.00",100,34,native.systemFontBold,40)

-- Main Function
function Main()
	titleBg = display.newImage('images/titleBg.png')
  titleBg.x = display.contentCenterX
  titleBg.y = display.contentCenterY
  
	playBtn = display.newImage('images/playBtn.png')
	playBtn.x = 200
  playBtn.y = 150
	titleView = display.newGroup(titleBg, playBtn)
	startButtonListeners('add')
  wormsHit = 0
end

-- startButton
function startButtonListeners(action)
	if(action == 'add') then
		playBtn:addEventListener('tap', showGameView)
	else
		playBtn:removeEventListener('tap', showGameView)
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
	prepareWorms()
end

-- Prepare worms
function prepareWorms()
	w1 = display.newImage( "images/地鼠.png",200,90)
  w2 = display.newImage( "images/地鼠.png",220,180 )
  w3 = display.newImage( "images/地鼠.png",200,265)
  w4 = display.newImage( "images/地鼠.png",98,90)
  w5 = display.newImage( "images/地鼠.png",119,180)
  w6 = display.newImage( "images/地鼠.png",99,265 )
  w7 = display.newImage( "images/地鼠.png",119,353 )
  w8 = display.newImage( "images/地鼠.png",13,353 )
  w9 = display.newImage( "images/地鼠.png",-5,265)
  w10 = display.newImage( "images/地鼠.png",-5,90)
  w11 = display.newImage( "images/地鼠.png",13,178)
  w12 = display.newImage( "images/地鼠.png",220,353 )
	worms = display.newGroup(w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12)
	for i = 1, worms.numChildren do
		worms[i]:addEventListener('tap', wormHit)
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
function wormHit:tap(e)
	audio.play(hit)
	wormsHit = wormsHit + 1
	score.text = wormsHit*2
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
  alertScore = display.newText(wormsHit*2, 110, 100, 
                                            native.systemFontBold, 50)
  alertScore:setTextColor(104, 33, 20)
  alertView:insert(alertScore)
  alertBox:addEventListener('tap', restart)
  S=40
    ss=0
end

-- ReStart
function restart()
  display.remove(alertView)
  display.remove(score)
  display.remove(worms)
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


