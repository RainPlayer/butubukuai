'''
Created on 2013-11-1

@author: lixingle
'''
import MySQLdb

from BuTuBuKuai import settings
conname=settings.conname
conuser = settings.conuser
conhost = settings.conhost
conpasswd = settings.conpasswd
condb = settings.condb
conport =settings.conport

def getAttentionCount(userid):
    
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    
    x = conn.cursor()
    
    try:
        mycount = x.execute("""select count(*) from BuTuBuKuai_attention where userid=%s """,(userid))
        mycount = x.fetchone()[0]
        conn.commit()
        x.close()
        conn.close()
    except:
        conn.rollback()
        x.close()
        conn.close()
    return mycount

def getAttentionUserIds(userid): #from attention table get all attention userids
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    cursor = conn.cursor()
    try:
        cursor.execute("""select * from BuTuBuKuai_attention where userid=%s """,(userid))
        rows = cursor.fetchall()
        list=[]
        
        for row in rows:
            count=0;
            for detail in row:
                count+=1
                if count==3:
                    list.append(detail)
                    
        conn.commit()
        cursor.close()
        conn.close()
        
    except:
        conn.rollback()
        cursor.close()
        conn.close()
    return list
    
def getAttentionsDetail(id):#get attention user deatils from user table
    mylist=getAttentionUserIds(id)
    
    
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    cursor = conn.cursor()
    try:
        users=[]
        userdic={}
        count=0
        for detail in mylist:
            count+=1
            cursor.execute("""select * from BuTuBuKuai_user where id=%s """,(detail))
            rows = cursor.fetchall()
            
            for row in rows:
                users.append(row)
                userdic[count]=row
            conn.commit()
      
        cursor.close()
        conn.close()    
    except:
        conn.rollback()
        cursor.close()
        conn.close()
    return userdic  

#add attention

def AddAttention(userid,attentionid):
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    cursor= conn.cursor()
   
    try:
        count = cursor.execute("""select count(*) from BuTuBuKuai_attention where userid=%s and attentionid=%s;""",(userid,attentionid))
        count = cursor.fetchone()[0]
        if count==0:
            cursor.execute("""INSERT INTO BuTuBuKuai_attention(userid,attentionid) VALUES (%s,%s)""",(userid,attentionid))
            conn.commit()
        cursor.close()
        conn.close()
        
    except:
        conn.rollback()
        cursor.close()
        conn.close()

def IfAttentioned(userid,attentionid):  # if userid attentioned attentionid
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    cursor= conn.cursor()
   
    try:
        count = cursor.execute("""select count(*) from BuTuBuKuai_attention where userid=%s and attentionid=%s;""",(userid,attentionid))
        count = cursor.fetchone()[0]
        conn.commit()
        cursor.close()
        conn.close()
        
    except:
        conn.rollback()
        cursor.close()
        conn.close()
    return count


def DeleteAttention(userid,attentionid):  # if userid attentioned attentionid
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    cursor= conn.cursor()
   
    try:
        cursor.execute("""select id from BuTuBuKuai_attention where userid=%s and attentionid=%s;""",(userid,attentionid))
        rows = cursor.fetchall()
        for row in rows:
            for rowid in row:
                deleteid=rowid
        if deleteid!=0:        
            cursor.execute("""delete from BuTuBuKuai_attention where id=%s;""",(deleteid)) #delete
        conn.commit()
        cursor.close()
        conn.close()
        
    except:
        conn.rollback()
        cursor.close()
        conn.close()
    



