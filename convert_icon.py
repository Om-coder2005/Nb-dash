import sys
from PIL import Image

def convert_to_ico(jpeg_path, ico_path):
    img = Image.open(jpeg_path)
    # The icon sizes Windows expects
    icon_sizes = [(256, 256), (128, 128), (64, 64), (48, 48), (32, 32), (16, 16)]
    # We must save as ICO format
    img.save(ico_path, format='ICO', sizes=icon_sizes)

if __name__ == '__main__':
    convert_to_ico(sys.argv[1], sys.argv[2])
