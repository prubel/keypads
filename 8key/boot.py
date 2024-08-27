import supervisor
import board
import digitalio
import storage
import usb_cdc
import usb_hid

# This is from the base kmk boot.py
# the below works for circuitpython 8, but is gone in 9
#supervisor.runtime.next_stack_limit = 4096 + 4096

# If this key is held during boot, don't run the code which hides the
# storage and disables serial. To use another key just count its row
# and column and use those pins. You can also use any other pins not
# already used in the matrix and make a button just for accesing your
# storage
col = digitalio.DigitalInOut(board.GP15)
row = digitalio.DigitalInOut(board.GP13)

# TODO: If your diode orientation is ROW2COL, then make row the output and col the input
row.switch_to_output(value=True)
col.switch_to_input(pull=digitalio.Pull.DOWN)

if not col.value:
    storage.disable_usb_drive()
    usb_cdc.disable()
    usb_hid.enable(boot_device=1)

row.deinit()
col.deinit()
