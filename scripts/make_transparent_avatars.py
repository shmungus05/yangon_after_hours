import os
from PIL import Image
from collections import deque

IMAGE_SOURCES = {
    "tea_master": r"C:\Users\Dell Latitude 5420\.gemini\antigravity-ide\brain\12f9a666-d72e-4bc6-b0b4-bafb61e940a8\tea_master_outline_1792935737209.jpg",
    "watchman": r"C:\Users\Dell Latitude 5420\.gemini\antigravity-ide\brain\12f9a666-d72e-4bc6-b0b4-bafb61e940a8\watchman_outline_1792935817442.jpg",
    "cook": r"C:\Users\Dell Latitude 5420\.gemini\antigravity-ide\brain\12f9a666-d72e-4bc6-b0b4-bafb61e940a8\cook_outline_1792935836363.jpg",
    "saya_min": r"C:\Users\Dell Latitude 5420\.gemini\antigravity-ide\brain\12f9a666-d72e-4bc6-b0b4-bafb61e940a8\saya_min_outline_1792935859996.jpg",
    "ma_thida": r"C:\Users\Dell Latitude 5420\.gemini\antigravity-ide\brain\12f9a666-d72e-4bc6-b0b4-bafb61e940a8\ma_thida_outline_1792935879360.jpg",
    "ko_aung": r"C:\Users\Dell Latitude 5420\.gemini\antigravity-ide\brain\12f9a666-d72e-4bc6-b0b4-bafb61e940a8\ko_aung_outline_1792935907547.jpg"
}

EXTRA_BG_SEEDS = {
    "watchman": [(280, 500)], # inside lantern handle loop
    "cook": [(740, 600)]       # between tongs and skewer
}

OUTPUT_DIR = r"d:\Projects\Digit7\yangon-after-hours\assets\avatars"
OUTLINE_COLOR = (14, 16, 24, 255) # Deep pixel dark ink outline

def process_avatar(name, src_path, output_png_path):
    print(f"Processing {name}...")
    img = Image.open(src_path).convert("RGB")
    w, h = img.size
    pixels = img.load()

    # Step 1: Flood fill from borders to identify outer background
    queue = deque()
    visited = [[False] * h for _ in range(w)]

    for x in range(w):
        queue.append((x, 0))
        queue.append((x, h - 1))
        visited[x][0] = True
        visited[x][h - 1] = True

    for y in range(h):
        queue.append((0, y))
        queue.append((w - 1, y))
        visited[0][y] = True
        visited[w - 1][y] = True

    # Add extra seed points for enclosed background holes
    if name in EXTRA_BG_SEEDS:
        for sx, sy in EXTRA_BG_SEEDS[name]:
            r, g, b = pixels[sx, sy]
            if r > 215 and g > 215 and b > 215:
                queue.append((sx, sy))
                visited[sx][sy] = True

    # Flood fill
    while queue:
        x, y = queue.popleft()
        r, g, b = pixels[x, y]
        if r > 210 and g > 210 and b > 210:
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                nx, ny = x + dx, y + dy
                if 0 <= nx < w and 0 <= ny < h and not visited[nx][ny]:
                    visited[nx][ny] = True
                    queue.append((nx, ny))

    # Step 2: Build RGBA image
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    out_pix = out.load()

    for y in range(h):
        for x in range(w):
            if not visited[x][y]:
                out_pix[x, y] = (pixels[x, y][0], pixels[x, y][1], pixels[x, y][2], 255)

    # Step 3: Add crisp 2-pixel dark outline to clean up JPEG compression fringe
    # 1. Darken border pixels inside the character that are near-white fringe
    for y in range(h):
        for x in range(w):
            if not visited[x][y]:
                is_edge = any(
                    visited[x + dx][y + dy]
                    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]
                    if 0 <= x + dx < w and 0 <= y + dy < h
                )
                if is_edge:
                    r, g, b, _ = out_pix[x, y]
                    if (r + g + b) / 3 > 130:
                        out_pix[x, y] = OUTLINE_COLOR

    # 2. Add outer outline pixels into the adjacent background (radius 2)
    final_img = out.copy()
    final_pix = final_img.load()

    for y in range(h):
        for x in range(w):
            if visited[x][y]:
                # check if close to character
                is_near = False
                for dx in range(-2, 3):
                    for dy in range(-2, 3):
                        if dx * dx + dy * dy <= 4:
                            nx, ny = x + dx, y + dy
                            if 0 <= nx < w and 0 <= ny < h and not visited[nx][ny]:
                                is_near = True
                                break
                    if is_near:
                        break
                if is_near:
                    final_pix[x, y] = OUTLINE_COLOR

    # Save PNG
    final_img.save(output_png_path, "PNG")
    print(f"Saved: {output_png_path}")

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for name, src_path in IMAGE_SOURCES.items():
        out_png = os.path.join(OUTPUT_DIR, f"{name}.png")
        process_avatar(name, src_path, out_png)
    print("All avatars successfully converted to transparent PNG with clean outline!")

if __name__ == "__main__":
    main()
