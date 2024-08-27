import board
import supervisor
import board
import digitalio

from kmk.kmk_keyboard import KMKKeyboard
from kmk.keys import KC
from kmk.scanners import DiodeOrientation
from kmk.handlers.sequences import send_string

keyboard = KMKKeyboard()

keyboard.row_pins = (board.GP11, board.GP13, board.GP18, board.GP20) # Cols
keyboard.col_pins = (board.GP15, board.GP16)             # Rows
keyboard.diode_orientation = DiodeOrientation.ROW2COL

# Keymap
keyboard.keymap = [
    [KC.get('A'),
     KC.get('2'),
     KC.get('3'),
     KC.get('4'),
     KC.get('5'),
     send_string("Have I shown you dot_OK?"), #KC.get('6'),
     send_string("Have you checked the time on your device?"), #KC.get('7'),
     send_string("Did you read the error message?"), #KC.get('8'),
     KC.get('X'), # extras, outside the 8 configured to catch errors
     KC.get('Z')] # extras, outside the 8 configured to catch errors
]

if __name__ == '__main__':
    keyboard.debug_enabled = False
    keyboard.go()
