"""Cut the Omar take into a short demo: chapters of (start, end, speed) pieces; prints chapter end times."""
import subprocess, sys, json
RAW, OUT = sys.argv[1], sys.argv[2]
CH = [
  [(0.0, 1.0, 1), (6.8, 12.0, 2), (12.0, 13.0, 1)],                      # 1 types, the name turns yellow
  [(17.6, 18.6, 1), (22.4, 23.6, 1), (30.0, 31.5, 1)],                   # 2 sends, reply, opens the receipt
  [(38.4, 49.7, 3), (49.7, 50.9, 1), (57.6, 59.3, 1)],                   # 3 second message, the reply asks one question
  [(66.8, 68.0, 1), (69.4, 70.6, 1), (73.7, 74.6, 1), (79.2, 80.8, 1)],  # 4 «مش عارف مع مني نحكي» -> people
  [(83.8, 85.2, 1)],                                                     # 5 another person, the drafted message
  [(90.1, 91.7, 1), (94.7, 96.9, 1)],                                    # 6 urgent screen
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
