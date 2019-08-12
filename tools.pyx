# cython: language_level=3
import random
import numpy as np
# 计算平均rgb值
cpdef cal_avg_rgb(int width, int height, object pix):
    cdef int avg_r, avg_g, avg_b
    avg_r, avg_g, avg_b = 0, 0, 0
    cdef int n = 1
    cdef int r, g, b
    cdef int i
    cdef int j
    for i in range(width):
        for j in range(height):
             r, g, b = pix[i, j]
             avg_r += r
             avg_g += g
             avg_b += b
             n += 1
    avg_r /= n
    avg_g /= n
    avg_b /= n
    return str(avg_r) + "-" + str(avg_g) + "-" + str(avg_b)

# 获取最佳素材(按平均rgb),version 1.0
# cpdef find_by_rgb(dict __all_img,sub_rgb):
#         cdef double sub_r, sub_g, sub_b
#         a,b,c = sub_rgb.split("-")
#         sub_r, sub_g, sub_b = float(a),float(b),float(c)
#         cdef float m = 255
#         cdef object k = ""
#         cdef double src_r, src_g, src_b
#         cdef double cur_dif
#         for key in __all_img.keys():
#             d,e,f = key.split("-")
#             src_r, src_g, src_b = float(d),float(e),float(f)
#             cur_dif = abs(sub_r - src_r) + abs(sub_g - src_g) + abs(
#                 sub_b - src_b)
#             if cur_dif < m:
#                 m = cur_dif
#                 k = key
#         return __all_img[k]

#获取最佳素材(按平均rgb),version 1.2
cpdef find_by_rgb(dict __all_img,sub_rgb):
        sub_r, sub_g, sub_b = sub_rgb.split("-")
        cdef double vec1 = np.sum([float(sub_r),float(sub_g),float(sub_b)]) 
        cdef list vec2 = []
        cdef dict keymap = {}
        cdef list subtract = []
        cdef list keymapitems = []
        cdef double src_r, src_g, src_b
        cdef double rgbsum
        cdef int  y,element
        cdef object z
        cdef object final_val
        for key in __all_img.keys():
            d,e,f = key.split("-")
            src_r, src_g, src_b = float(d),float(e),float(f)
            rgbsum = np.sum([src_r, src_g, src_b])
            vec2.append(rgbsum)
            keymap.update({key: rgbsum})

        subtract = np.fabs(np.subtract(vec1,vec2)).tolist()
        
        keymapitems = list(keymap.items()) # keymap.items, 把字典keymap变成元组列表后迭代它，[('r-g-b','图片对象数据...')]
        for y, element in enumerate(subtract): 
            keymap[ keymapitems[y][0] ] = element   # keymapitems[y][0],即keymap字典的key
        subtract.sort()
        final_val = random.choice(subtract[:3])  #找出最小的前三个差值,即[subtract[0],subtract[1],subtract[2]]，幷随机取一个
        final_key = [z for z in keymap if keymap[z] == final_val][0]
        return __all_img[final_key]


