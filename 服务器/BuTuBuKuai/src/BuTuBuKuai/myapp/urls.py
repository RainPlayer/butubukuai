# -*- coding: utf-8 -*-
from django.conf.urls import patterns, url, include
from rest_framework import  routers
import  views

router = routers.DefaultRouter()
router.register(r'btbkimage', views.DocumentViewSet)


urlpatterns = patterns('BuTuBuKuai.myapp.views',
    #添加内涵图片的好评 id
    url('^addNHImagePraiseNumber/id=(?P<id>[0-9]+)/$',views.AddNeiHanImagePraiseNumber.as_view()), 
    #添加内涵图片的差评 id
    url('^addNHImageBadNumber/id=(?P<id>[0-9]+)/$',views.AddNeiHanImageBadNumber.as_view()),  
     #comment  .....................................................................
    #添加评论 pid observer discuss
    url('^insertNHImageComment/pid=(?P<pid>\w{1,50})&observer=(?P<observer>[\w_\u4e00-\u9fa5]{1,100})&discuss=(?P<discuss>.+)/$',views.InsertNHImageComment.as_view()),
   #通过原文的id获得所有评论 
    url('^getNHImageCommentByPid/pid=(?P<pid>\w{1,50})/$', views.GetNHImageCommentByPid.as_view()),
   #增加评论的好评
    url('^addNHImageComPraiseNumber/id=(?P<id>[0-9]+)/$',views.AddNHImageComPraiseNumberById.as_view()),
     
     
                      
    url(r'^', include(router.urls)),
    url(r'^list/$', 'list', name='list'),
    url(r'^userheaderimageupload/$', 'userheaderimageupload', name='userheaderimageupload'),
)
