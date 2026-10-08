"""Cut take 8 into a short demo: chapters of (start, end, speed) pieces; prints chapter end times."""
import subprocess, sys, json
RAW, OUT = sys.argv[1], sys.argv[2]
CH = [
  [(0.0, 1.0, 1), (7.0, 12.3, 2), (12.3, 13.3, 1)],                      # 1 types, the name turns yellow
  [(17.7, 18.7, 1), (21.8, 23.0, 1), (29.8, 31.3, 1)],                   # 2 sends, reply, opens the receipt
  [(38.4, 45.9, 2.5), (49.8, 50.8, 1), (53.3, 55.0, 1)],                 # 3 second message, the reply asks one question
  [(63.4, 64.6, 1), (66.2, 67.4, 1), (70.1, 71.0, 1), (75.7, 77.3, 1)],  # 4 «مش عارفة مع مني نحكي» -> people
  [(80.3, 81.8, 1)],                                                     # 5 another person, the drafted message
  [(86.6, 88.2, 1), (91.2, 93.6, 1)],                   # 6 urgent screen
]
parts, t, ends = [], 0.0, []
for ch in CH:
    for a, b, k in ch:
        parts.append((a, b, k)); t += (b - a) / k
    ends.append(round(t, 2))
f = []
for n, (a, b, k) in enumerate(parts):
    f.append(f"[0:v]trim={a}:{b},setpts=(PTS-STARTPTS)/{k}[v{n}]")
f.append("".join(f"[v{n}]" for n in range(len(parts))) + f"concat=n={len(parts)}:v=1:a=0[out]")
subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", RAW, "-filter_complex", ";".join(f), "-map", "[out]",
                "-c:v", "libopenh264", "-b:v", "3M", "-pix_fmt", "yuv420p", "-movflags", "+faststart", OUT], check=True)
print(json.dumps(ends))
