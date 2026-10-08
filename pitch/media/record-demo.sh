#!/bin/bash
# Records the Omar demo on a connected Android phone (fictional persona; the replies come live from the backend).
#   ./record-demo.sh <out-dir>        writes <out-dir>/raw.mp4 (about 100 s)
# Needs: the release app installed, the backend reachable, and ADBKeyboard (com.android.adbkeyboard) for Arabic input.
# Do Not Disturb is turned on while recording so no notification (real names) appears, and turned off after.
# Then: ffmpeg -i raw.mp4 -vf "fps=30,crop=1080:2130:0:92,scale=720:-2" -c:v libopenh264 -b:v 3M cfr.mp4
#       python3 cut.py cfr.mp4 demo.mp4      (the 25-second chaptered cut for slide 9)
#       ffmpeg -i cfr.mp4 -an -vf scale=540:-2 -c:v libopenh264 -b:v 450k demo-full.mp4   (the uncut backup)
set -u
OUT="${1:?usage: record-demo.sh <out-dir>}"
DEV="${ADB_SERIAL:-$(adb devices | awk 'NR>1 && $2=="device" {print $1; exit}')}"
tapt(){ adb -s "$DEV" shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1; b=$(adb -s "$DEV" shell cat /sdcard/u.xml | grep -o "$1[^>]*bounds=\"[^\"]*\"" | head -${2:-1} | tail -1 | grep -o '\[[0-9]*,[0-9]*\]\[[0-9]*,[0-9]*\]'); [ -z "$b" ] && { echo "not found: $1"; return 1; }; read x1 y1 x2 y2 <<<$(echo $b | tr '[],' '   '); adb -s "$DEV" shell input tap $(((x1+x2)/2)) $(((y1+y2)/2)); }
say(){ for w in $1; do adb -s "$DEV" shell "am broadcast -a ADB_INPUT_TEXT --es msg '$w '" >/dev/null; sleep 0.35; done; }
waitreply(){ for k in $(seq 1 40); do sleep 1; adb -s "$DEV" shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1; n=$(adb -s "$DEV" shell cat /sdcard/u.xml | grep -o "$1" | wc -l); [ "$n" -ge "$2" ] && return 0; done; }
# Omar: the demo launch fixes the welcome line and addresses him as «ولد» (nothing is stored)
adb -s "$DEV" shell cmd notification set_dnd priority
adb -s "$DEV" shell am force-stop ly.manara.khutwa
adb -s "$DEV" shell "am start -n ly.manara.khutwa/.MainActivity --es khutwa.welcome 'خطوة بخطوة وكلها تتسهل' --ez khutwa.feminine false" >/dev/null
sleep 3.5; tapt 'text="فاهمة، نبي نبدا"' || tapt 'text="فاهم، نبي نبدا"'; sleep 2.5
adb -s "$DEV" shell ime set com.android.adbkeyboard/.AdbIME >/dev/null; sleep 1
adb -s "$DEV" shell screenrecord --bit-rate 10000000 --time-limit 180 /sdcard/khutwa-demo.mp4 &
REC=$!
sleep 4.5
tapt 'class="android.widget.EditText"'; sleep 1.2
say "صاحبي يوسف ما عادش يحكي معاي، ومش عارف علاش"
sleep 1.5; tapt 'content-desc="ابعت"'
waitreply 'text="خطوة"' 2; sleep 3
tapt 'text="شوف شن وصل"' || tapt 'text="شوفي شن وصل"'; sleep 5
tapt 'class="android.widget.EditText"'; sleep 0.8
# answer what Khutwa actually asked: did he try, since when, a mutual friend, does anyone know, someone else in his life
R1=$(adb -s "$DEV" shell cat /sdcard/u.xml | grep -o 'text="[^"]*؟"' | grep -v 'text="مع مني نحكي؟"' | tail -1)
echo "khutwa asked: $R1"
BASE="تخاصمنا من شهر على حاجة تافهة، وبعتتله مرتين وما ردش"
if echo "$R1" | grep -q "وجه لوجه\|تتلاقى\|تلاقيت\|تشوفه\|قابلته\|حكيت معاه\|جربت"; then
  say "لا، $BASE"
elif echo "$R1" | grep -q "امتا\|امتى\|قداش\|من وقتاش"; then
  say "من شهر تقريبًا. تخاصمنا على حاجة تافهة، وبعتتله مرتين وما ردش"
elif echo "$R1" | grep -q "مشترك\|بينكم\|بيناتكم"; then
  say "لا، ما فيش حد بينا. $BASE"
elif echo "$R1" | grep -q "حد يعرف\|حد عارف\|حد دري"; then
  say "حتى حد ما يعرف. $BASE"
elif echo "$R1" | grep -q "حد ثاني\|حد قريب\|حد في\|تثق\|ترتاح\|تقدر تحكي\|تفضفض"; then
  say "هو أقرب واحد ليا، ما عنديش غيره. $BASE"
else
  say "مش عارف والله. $BASE"
fi
sleep 1.2; tapt 'content-desc="ابعت"'
waitreply 'text="خطوة"' 3; sleep 4
tapt 'text="مع مني نحكي؟"'
waitreply 'ابعتها بنفسك' 1; sleep 2
adb -s "$DEV" shell input swipe 540 1600 540 700 900; sleep 3.5
adb -s "$DEV" shell input swipe 540 1500 540 1050 700; sleep 3
tapt 'text="نحتاج مساعدة توا"'; sleep 4.5
adb -s "$DEV" shell input swipe 540 1600 540 900 900; sleep 2.5
adb -s "$DEV" shell input keyevent 4; sleep 2
adb -s "$DEV" shell pkill -INT screenrecord; wait $REC 2>/dev/null; sleep 2
adb -s "$DEV" shell ime set com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME >/dev/null
adb -s "$DEV" pull /sdcard/khutwa-demo.mp4 "$OUT/raw.mp4" >/dev/null && echo pulled
adb -s "$DEV" shell cmd notification set_dnd off
