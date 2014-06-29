# -*- coding: UTF-8 -*-  
'''
Created on 2013-9-26

@author: lixingle
'''
import hashlib

def getMd5(str):  
    data = str
    m = hashlib.md5(data.encode("utf-8"))
    return (m.hexdigest())
 