add-symbol-file app.o 0x00000000000900c8
add-symbol-file color.o 0x0000000000090908
add-symbol-file shapes.o 0x00000000000909d0
add-symbol-file utils.o 0x0000000000110fe8

b animloop
b fill
b fillscreen_gradient_color_to_color
b drawstars
b drawellipse
b drawsquare_gradient
b adjust_color_brightness
b drawchar_direct
b delay
