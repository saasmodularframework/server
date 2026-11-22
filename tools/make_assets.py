import math, os, subprocess, sys
from PIL import Image, ImageDraw

OUT = sys.argv[1]
for d in ('gifs', 'images', 'videos'):
    os.makedirs(f'{OUT}/{d}', exist_ok=True)

def hx(s): return tuple(int(s[i:i+2], 16) for i in (1, 3, 5))
LIGHT, CREAM, EMER, NAVY = hx('#D4AF37'), hx('#F2E8C9'), hx('#0B6E4F'), hx('#0A1A2F')
BURG, TEAL, COPPER, BLACK = hx('#6B1E2E'), hx('#1F7A8C'), hx('#B87333'), hx('#0B0B0F')
PAL = [
    (BLACK, LIGHT, CREAM, EMER), (NAVY, LIGHT, CREAM, TEAL), (BURG, LIGHT, CREAM, BLACK),
    (EMER, LIGHT, CREAM, NAVY), (BLACK, COPPER, CREAM, BURG), (NAVY, CREAM, LIGHT, BURG),
    (TEAL, LIGHT, CREAM, BLACK),
]
R = 480

def mix(a, b, t): return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))
def pol(cx, cy, r, a): return (cx + r * math.cos(a), cy + r * math.sin(a))

def sunburst(d, t, p, n=24):
    bg, c1, c2, c3 = p; c = R / 2
    rot = t * 2 * math.pi / n * 2
    for i in range(n):
        a0 = rot + i * 2 * math.pi / n; a1 = a0 + math.pi / n
        d.polygon([(c, c), pol(c, c, R, a0), pol(c, c, R, a1)], fill=c1 if i % 2 == 0 else c3)
    for k, col in ((120, c2), (96, bg), (70, c1), (44, bg)):
        d.ellipse([c - k, c - k, c + k, c + k], fill=col)

def fans(d, t, p):
    bg, c1, c2, c3 = p; w = 80; off = (t * w) % w
    for row in range(-1, 14):
        y = row * w * 0.5 + 40
        for col in range(-2, 8):
            x = col * w + (w / 2 if row % 2 else 0) - off
            for k, cc in enumerate((c1, c3, c2, bg)):
                rr = w / 2 * (1 - k * 0.22)
                d.pieslice([x - rr, y - rr, x + rr, y + rr], 180, 360, fill=cc)
                d.pieslice([x - rr, y, x + rr, y + 2 * rr], 0, 0, fill=cc)

    for row in range(-1, 14):
        y = row * w * 0.5 + 40
        for col in range(-2, 8):
            x = col * w + (w / 2 if row % 2 else 0) - off
            for k, cc in enumerate((c1, c3, c2, bg)):
                rr = w / 2 * (1 - k * 0.22)
                d.pieslice([x - rr, y - rr, x + rr, y + rr], 0, 180, fill=cc)

def chevrons(d, t, p):
    bg, c1, c2, c3 = p; h = 60; off = (t * h * 2) % (h * 2)
    for i in range(-2, 12):
        y = i * h - off + h * 2
        col = (c1, bg, c3, bg)[i % 4]
        d.polygon([(0, y), (R / 2, y - h), (R, y), (R, y + h * 0.5), (R / 2, y - h * 0.5), (0, y + h * 0.5)], fill=col)
    d.rectangle([R / 2 - 4, 0, R / 2 + 4, R], fill=c2)

def arches(d, t, p):
    bg, c1, c2, c3 = p; cx = R / 2
    for k in range(9):
        w = R * 0.46 - k * 24; top = 70 + k * 24
        cols = (c1, c2, c3, bg)
        col = cols[(k + int(t * 4)) % 4]
        d.rounded_rectangle([cx - w, top, cx + w, R], radius=int(w), fill=col)
    d.ellipse([cx - 14, 190, cx + 14, 218], fill=c2)

def zigzag(d, t, p):
    bg, c1, c2, c3 = p; step = 48; off = (t * step * 2) % (step * 2)
    for row in range(10):
        y0 = row * 52 + 10; col = (c1, c3, c2)[row % 3]
        pts = []
        for i in range(-2, 14):
            pts.append((i * step - off + (step if row % 2 else 0), y0 + (30 if i % 2 else 0)))
        d.line(pts, fill=col, width=10, joint='curve')
    d.rectangle([0, 0, R, 12], fill=c1); d.rectangle([0, R - 12, R, R], fill=c1)

def ziggurat(d, t, p):
    bg, c1, c2, c3 = p; cx = R / 2; steps = 8
    for k in range(steps):
        w = R * 0.46 - k * 24; top = R - 50 - (k + 1) * 44
        lit = (k == int(t * steps * 2) % (steps * 2)) or (k == (steps * 2 - 1 - int(t * steps * 2)) % (steps * 2))
        d.rectangle([cx - w, top, cx + w, R - 50 - k * 44], fill=c2 if lit else (c1 if k % 2 == 0 else c3), outline=bg, width=4)
    d.rectangle([cx - 5, 20, cx + 5, 60], fill=c1)
    d.polygon([(cx, 8), (cx - 14, 40), (cx + 14, 40)], fill=c2)

def lattice(d, t, p):
    bg, c1, c2, c3 = p; s = 80
    for i in range(-1, 8):
        for j in range(-1, 8):
            cx, cy = i * s, j * s; k = (i + j) % 6
            glow = 0.5 + 0.5 * math.sin(2 * math.pi * (t + k / 6))
            d.polygon([(cx, cy - s / 2), (cx + s / 2, cy), (cx, cy + s / 2), (cx - s / 2, cy)], fill=mix(c3, c1, glow), outline=c2, width=3)
            r = 9 * (0.5 + glow)
            d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=c2)

def starburst(d, t, p):
    bg, c1, c2, c3 = p; c = R / 2
    for layer, (n, rad, col, dirn) in enumerate(((16, 230, c1, 1), (16, 190, c3, -1), (8, 130, c2, 1), (8, 80, bg, -1))):
        a0 = dirn * t * 2 * math.pi / n
        pts = []
        for i in range(n * 2):
            a = a0 + i * math.pi / n; r = rad if i % 2 == 0 else rad * 0.55
            pts.append(pol(c, c, r, a))
        d.polygon(pts, fill=col)
    d.ellipse([c - 22, c - 22, c + 22, c + 22], fill=c2)

def rings(d, t, p):
    bg, c1, c2, c3 = p; c = R / 2
    for k in range(9, 0, -1):
        r = k * 26
        d.ellipse([c - r, c - r, c + r, c + r], fill=(c1, bg, c3, c2)[(k + int(t * 4)) % 4])
    for i in range(12):
        a = t * 2 * math.pi + i * math.pi / 6
        x, y = pol(c, c, 180, a)
        d.ellipse([x - 9, y - 9, x + 9, y + 9], fill=c2)

def spire(d, t, p):
    bg, c1, c2, c3 = p; cx = R / 2
    for k in range(6):
        w = 170 - k * 26; top = 330 - k * 46
        d.pieslice([cx - w, top - w * 0.8, cx + w, top + w * 0.8], 180, 360, fill=(c1, c3, c2)[k % 3], outline=bg, width=4)
    d.polygon([(cx, 10), (cx - 14, 200), (cx + 14, 200)], fill=c2)
    gy = 20 + (t * 300) % 300
    d.ellipse([cx - 10, gy - 10, cx + 10, gy + 10], fill=c1)
    d.rectangle([cx - 190, 380, cx + 190, 420], fill=c1)
    d.rectangle([cx - 150, 420, cx + 150, 452], fill=c3)

def gear(d, t, p):
    bg, c1, c2, c3 = p; c = R / 2; n = 14
    for ring, (r0, r1, col, dirn) in enumerate(((210, 170, c1, 1), (150, 110, c3, -1))):
        a0 = dirn * t * 2 * math.pi / n
        for i in range(n):
            a = a0 + i * 2 * math.pi / n
            d.polygon([pol(c, c, r1, a - 0.09), pol(c, c, r0, a - 0.05), pol(c, c, r0, a + 0.05), pol(c, c, r1, a + 0.09)], fill=col)
        d.ellipse([c - r1, c - r1, c + r1, c + r1], fill=col)
    d.ellipse([c - 100, c - 100, c + 100, c + 100], fill=bg)
    d.ellipse([c - 60, c - 60, c + 60, c + 60], fill=c2)
    d.ellipse([c - 24, c - 24, c + 24, c + 24], fill=bg)

def flutes(d, t, p):
    bg, c1, c2, c3 = p; w = 40
    for i in range(12):
        x = i * w
        d.rectangle([x, 0, x + w - 6, R], fill=(c1, c3)[i % 2])
        for j in range(-2, 12):
            y = j * 60 + (t * 60 * (1 if i % 2 else -1)) % 60
            d.rectangle([x + 8, y, x + w - 14, y + 22], fill=c2 if i % 2 else bg)
    d.rectangle([0, 0, R, 24], fill=c2); d.rectangle([0, R - 24, R, R], fill=c2)

def scales(d, t, p):
    bg, c1, c2, c3 = p; r = 60; off = (t * r) % r
    for row in range(-1, 18):
        y = row * r * 0.5 - off * 0.0
        for col in range(-2, 9):
            x = col * r * 2 + (r if row % 2 else 0) + off * (1 if row % 2 else -1)
            for k, cc in enumerate((c1, c2, c3, bg)):
                rr = r * (1 - k * 0.22)
                d.ellipse([x - rr, y - rr, x + rr, y + rr], fill=cc, outline=bg)

def squares(d, t, p):
    bg, c1, c2, c3 = p; c = R / 2
    for k in range(10, 0, -1):
        s = k * 26; a = t * math.pi / 2 * (1 if k % 2 else -1) + k * 0.12
        pts = [pol(c, c, s * 1.2, a + math.pi / 4 + i * math.pi / 2) for i in range(4)]
        d.polygon(pts, fill=(c1, bg, c3, c2)[k % 4], outline=bg)

MOTIFS = [sunburst, fans, chevrons, arches, zigzag, ziggurat, lattice, starburst, rings, spire, gear, flutes, scales, squares]

def frame(i, t, size=R):
    p = PAL[i % len(PAL)]
    im = Image.new('RGB', (R, R), p[0]); d = ImageDraw.Draw(im)
    MOTIFS[i](d, t, p)
    d.rectangle([0, 0, R - 1, R - 1], outline=p[1], width=10)
    d.rectangle([22, 22, R - 23, R - 23], outline=p[2], width=3)
    return im if size == R else im.resize((size, size), Image.LANCZOS)

FR = 12
for i in range(14):
    n = i + 1
    frames = [frame(i, k / FR, 260) for k in range(FR)]
    q = [f.quantize(colors=40, method=Image.MEDIANCUT, dither=Image.NONE) for f in frames]
    q[0].save(f'{OUT}/gifs/{n:02d}.gif', save_all=True, append_images=q[1:], duration=110, loop=0, optimize=True, disposal=2)
    big = frame(i, 0.3, 480)
    wide = Image.new('RGB', (640, 420), PAL[i % len(PAL)][0])
    wide.paste(big, (80, -30))
    wd = ImageDraw.Draw(wide)
    for k in range(0, 640, 40):
        wd.line([(k, 0), (k + 20, 12)], fill=PAL[i % len(PAL)][1], width=3)
    wide.save(f'{OUT}/images/{n:02d}.jpg', quality=82, optimize=True)

tmp = '/home/claude/gen/frames'; os.makedirs(tmp, exist_ok=True)
for f in os.listdir(tmp): os.remove(f'{tmp}/{f}')
idx = 0
for m in (0, 7, 3, 9, 10, 13):
    for k in range(48):
        frame(m, (k % 24) / 24 if m not in (3,) else k / 48, 320).save(f'{tmp}/f{idx:04d}.png'); idx += 1
subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-framerate', '24', '-i', f'{tmp}/f%04d.png', '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '28', '-movflags', '+faststart', f'{OUT}/videos/reel.mp4'], check=True)
print('done')

