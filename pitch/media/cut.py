"""Cut the Omar take into a short demo: chapters of (start, end, speed) pieces; prints chapter end times."""
import subprocess, sys, json
RAW, OUT = sys.argv[1], sys.argv[2]
CH = [
  [(0.0, 1.0, 1), (8.6, 13.0, 2), (13.0, 14.0, 1)],                     # 1 types, the name turns yellow
  [(18.3, 19.3, 1), (22.0, 23.0, 1), (29.0, 30.5, 1), (37.6, 39.2, 1)],  # 2 sends, the reply asks one question, opens the receipt
  [(45.8, 50.6, 3), (54.2, 55.2, 1), (57.3, 60.3, 1)],                   # 3 second message, a gentle reply
  [(67.6, 68.8, 1), (70.8, 72.0, 1), (75.2, 76.4, 1), (80.2, 81.8, 1)],  # 4 «مش عارف مع مني نحكي» -> people
  [(84.8, 87.0, 1)],                                                     # 5 another person, the drafted message
  [(91.0, 92.8, 1), (95.4, 97.8, 1)],                                    # 6 urgent screen
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
