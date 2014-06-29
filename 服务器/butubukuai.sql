CREATE DATABASE  IF NOT EXISTS `butubukuai` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `butubukuai`;
-- MySQL dump 10.13  Distrib 5.5.24, for osx10.5 (i386)
--
-- Host: localhost    Database: butubukuai
-- ------------------------------------------------------
-- Server version	5.5.28-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `butubukuai_attention`
--

DROP TABLE IF EXISTS `butubukuai_attention`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_attention` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `attentionid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_attention`
--

LOCK TABLES `butubukuai_attention` WRITE;
/*!40000 ALTER TABLE `butubukuai_attention` DISABLE KEYS */;
INSERT INTO `butubukuai_attention` VALUES (3,3,4),(4,4,5),(5,6,3),(9,14,13),(10,3,13),(11,3,5),(15,13,9),(33,22,5),(35,22,1),(36,22,9),(37,1,5),(38,13,2);
/*!40000 ALTER TABLE `butubukuai_attention` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `butubukuai_collection`
--

DROP TABLE IF EXISTS `butubukuai_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `collector` varchar(100) NOT NULL,
  `collectiontype` varchar(45) NOT NULL,
  `content` text NOT NULL,
  `pid` int(11) DEFAULT NULL,
  `pmd5code` varchar(100) DEFAULT NULL,
  `imageurl` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_collection`
--

LOCK TABLES `butubukuai_collection` WRITE;
/*!40000 ALTER TABLE `butubukuai_collection` DISABLE KEYS */;
INSERT INTO `butubukuai_collection` VALUES (1,'李兴乐','poetry','风声雨声读书声声声入耳',2,'asfgrts',NULL),(2,'李兴乐','nhimage','八旬老太威武',60,NULL,'documents/2013/10/24/201310241820570690.png'),(3,'李兴乐','duanzi','四个人在打麻将。A的电话响了，B开玩笑的说：快接快接，你的炮友来电话了……其他人轰然大笑。A接过电话，说了几句把电话递给B,说，你老婆打我电话找你……',1,'cxvxcvxcv1',NULL),(9,'李兴乐','duanzi','校长在学校见一个小家伙被罚站在楼道，还自个在偷偷乐。于是问他：“你为啥被罚站了？”他说：“昨天我吃太多黄豆了，还喝了凉水。结果在课上我放了一个一分钟的长屁，老师就把我赶出来了。”“那你为啥乐呢？”校长问 “老师和 同学还在教室呢 ……”',5,'dsfgsdfgdsfg5','(null)'),(10,'李兴乐','duanzi','谈下土豪金5s的感受:外观上和5s区别不算太大，所谓金色其实更贴近香槟色，比想 象中好看很多，屏幕也没明显差别。最直观的提升是运行速度，A7处理器就是快，打开各种app和多任务处理时非常流畅。其他功能还没来得及看，站在我前面玩手机 这孙子已经下车了……',3,'dszfg3','(null)'),(11,'王长超','duanzi','最近想换个电脑，苦于没理由一直没给爸妈说。正好今天看见爸妈在看新闻一大学 生因为家人不给买手机跳河了，真是天助我也啊，连忙说到想换个新电脑，只见他俩斜我一眼，然后开始商量葬礼上应该穿什么衣服...',2,'dsafgasd2','(null)'),(12,'王长超','duanzi','一老师在上课时说“在我的字典里就没有“失败”两个字”结果从下面传来一本字典。小新同学说了一句“老师我的字典借你”',9,'eb1908cb6cc7c14ffa02a18a052710e9','(null)'),(14,'王长超','duanzi','校长在学校见一个小家伙被罚站在楼道，还自个在偷偷乐。于是问他：“你为啥被罚站了？”他说：“昨天我吃太多黄豆了，还喝了凉水。结果在课上我放了一个一分钟的长屁，老师就把我赶出来了。”“那你为啥乐呢？”校长问 “老师和 同学还在教室呢 ……”',5,'dsfgsdfgdsfg5','(null)'),(25,'王长超','duanzi','和前面一看书妹妹等公交，上车后妹纸边看书边拿一元钱在刷卡机蹭了一下装其囗袋，我在后面笑喷了，心想这二货，然后我隨手把卡投进了投币机里...',8,'a2de971ee2cfbd05fd10e3f079c4d76c','(null)'),(26,'王尼玛','duanzi','校长在学校见一个小家伙被罚站在楼道，还自个在偷偷乐。于是问他：“你为啥被罚站了？”他说：“昨天我吃太多黄豆了，还喝了凉水。结果在课上我放了一个一分钟的长屁，老师就把我赶出来了。”“那你为啥乐呢？”校长问 “老师和 同学还在教室呢 ……”',5,'dsfgsdfgdsfg5','(null)'),(27,'王尼玛','duanzi','四个人在打麻将。A的电话响了，B开玩笑的说：快接快接，你的炮友来电话了……其他人轰然大笑。A接过电话，说了几句把电话递给B,说，你老婆打我电话找你……',1,'cxvxcvxcv1','(null)'),(28,'王尼玛','duanzi','张飞献给刘备一只猴子，刘备爱不释手，问道：＂三弟，这是什么猴？＂＂吼猴。 ＂＂说人话！＂＂吼猴。＂刘备一个耳光甩过来：＂卖你麻痹萌！＂',4,'dfgdsfg4','(null)'),(29,'王尼玛','poetry','银不吐槽枉骚年。。。',5,'b8cdbfe338b1dd1a1da5e1c42b5c4904','(null)'),(30,'王尼玛','poetry','昨夜西风凋碧树',3,'asfgrtsdszgs','(null)'),(31,'王尼玛','poetry','风声雨声读书声声声入耳',2,'asfgrts','(null)'),(32,'王尼玛','poetry','天王盖地虎',1,'asgfadfsgfdsgeer','(null)'),(40,'王尼玛','nhimage','支持老太太...',60,'','documents/2013/10/24/201310241820570690.png'),(41,'王尼玛','duanzi','两老太太在门口聊天，甲:“现在社会进步科技发达了，以前养鸡养鸭半年多才长熟，现在两月不到就可以宰来吃了。（激素）”乙:“怪不得！我那儿媳妇刚过门才一个礼拜这都快生了！”（……）',7,'a340dd2dda7b70ac76d3cc3b43eda6f2','(null)'),(42,'王长超','nhimage','支持老太太...',60,'','documents/2013/10/24/201310241820570690.png'),(43,'李兴乐','duanzi','xcvzdsc',15,'919437236f8e47be9c2b373ee9cadd8c','(null)'),(44,'王长超','poetry','银不吐槽枉骚年。。。',5,'b8cdbfe338b1dd1a1da5e1c42b5c4904','(null)'),(45,'王长超','duanzi','银不吐槽枉骚年。。。',18,'b8cdbfe338b1dd1a1da5e1c42b5c4904','(null)'),(46,'lixingle','duanzi','校长在学校见一个小家伙被罚站在楼道，还自个在偷偷乐。于是问他：“你为啥被罚站了？”他说：“昨天我吃太多黄豆了，还喝了凉水。结果在课上我放了一个一分钟的长屁，老师就把我赶出来了。”“那你为啥乐呢？”校长问 “老师和 同学还在教室呢 ……”',5,'dsfgsdfgdsfg5','(null)'),(47,'lixingle','duanzi','张飞献给刘备一只猴子，刘备爱不释手，问道：＂三弟，这是什么猴？＂＂吼猴。 ＂＂说人话！＂＂吼猴。＂刘备一个耳光甩过来：＂卖你麻痹萌！＂',4,'dfgdsfg4','(null)'),(48,'lixingle','nhimage','樱桃',1,'','documents/2013/10/25/201310251912490260.png'),(49,'lixingle','poetry','风声雨声读书声声声入耳',2,'asfgrts','(null)'),(50,'lixingle','poetry','天王盖地虎',1,'asgfadfsgfdsgeer','(null)'),(51,'lixingle','duanzi','最近想换个电脑，苦于没理由一直没给爸妈说。正好今天看见爸妈在看新闻一大学 生因为家人不给买手机跳河了，真是天助我也啊，连忙说到想换个新电脑，只见他俩斜我一眼，然后开始商量葬礼上应该穿什么衣服...',2,'dsafgasd2','(null)'),(52,'lixingle','duanzi','谈下土豪金5s的感受:外观上和5s区别不算太大，所谓金色其实更贴近香槟色，比想 象中好看很多，屏幕也没明显差别。最直观的提升是运行速度，A7处理器就是快，打开各种app和多任务处理时非常流畅。其他功能还没来得及看，站在我前面玩手机 这孙子已经下车了……',3,'dszfg3','(null)'),(53,'lixingle','poetry','银不吐槽枉骚年。。。',5,'b8cdbfe338b1dd1a1da5e1c42b5c4904','(null)'),(54,'lixingle','nhimage','支持老太太...',60,'','documents/2013/10/24/201310241820570690.png'),(55,'李兴乐','nhimage','adsgsfg啊是sghdfgh的如果是大富豪的方式sxds',4,'dsfgs','sagras.jpg');
/*!40000 ALTER TABLE `butubukuai_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `butubukuai_myimage`
--

DROP TABLE IF EXISTS `butubukuai_myimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_myimage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `headerimage` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_myimage`
--

LOCK TABLES `butubukuai_myimage` WRITE;
/*!40000 ALTER TABLE `butubukuai_myimage` DISABLE KEYS */;
INSERT INTO `butubukuai_myimage` VALUES (1,'1b8f_beautiful-iphone-wallpaper-3.jpg');
/*!40000 ALTER TABLE `butubukuai_myimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `butubukuai_neihanarticle`
--

DROP TABLE IF EXISTS `butubukuai_neihanarticle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_neihanarticle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `date` varchar(45) NOT NULL,
  `article` text NOT NULL,
  `md5code` varchar(45) NOT NULL,
  `praisenumber` int(10) DEFAULT '0',
  `badnumber` int(10) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_neihanarticle`
--

LOCK TABLES `butubukuai_neihanarticle` WRITE;
/*!40000 ALTER TABLE `butubukuai_neihanarticle` DISABLE KEYS */;
INSERT INTO `butubukuai_neihanarticle` VALUES (1,1,'13-12-23 12:00','四个人在打麻将。A的电话响了，B开玩笑的说：快接快接，你的炮友来电话了……其他人轰然大笑。A接过电话，说了几句把电话递给B,说，你老婆打我电话找你……','cxvxcvxcv1',33,216),(2,2,'09-12 13:21','最近想换个电脑，苦于没理由一直没给爸妈说。正好今天看见爸妈在看新闻一大学 生因为家人不给买手机跳河了，真是天助我也啊，连忙说到想换个新电脑，只见他俩斜我一眼，然后开始商量葬礼上应该穿什么衣服...','dsafgasd2',9,29),(3,3,'12-23 12:23','谈下土豪金5s的感受:外观上和5s区别不算太大，所谓金色其实更贴近香槟色，比想 象中好看很多，屏幕也没明显差别。最直观的提升是运行速度，A7处理器就是快，打开各种app和多任务处理时非常流畅。其他功能还没来得及看，站在我前面玩手机 这孙子已经下车了……','dszfg3',19,18),(4,1,'12-21 12:23','张飞献给刘备一只猴子，刘备爱不释手，问道：＂三弟，这是什么猴？＂＂吼猴。 ＂＂说人话！＂＂吼猴。＂刘备一个耳光甩过来：＂卖你麻痹萌！＂','dfgdsfg4',9,7),(5,5,'23-23 23:23','校长在学校见一个小家伙被罚站在楼道，还自个在偷偷乐。于是问他：“你为啥被罚站了？”他说：“昨天我吃太多黄豆了，还喝了凉水。结果在课上我放了一个一分钟的长屁，老师就把我赶出来了。”“那你为啥乐呢？”校长问 “老师和 同学还在教室呢 ……”','dsfgsdfgdsfg5',55,44),(6,6,'2013-09-26 21:09:06','四个人在打麻将。A的电话响了，B开玩笑的说：快接快接，你的炮友来电话了……其他人轰然大笑。A接过电话，说了几句把电话递给B,说，你老婆打我电话找你……','asfgrts6',1,4),(7,7,'2013-09-26 08:15:23','两老太太在门口聊天，甲:“现在社会进步科技发达了，以前养鸡养鸭半年多才长熟，现在两月不到就可以宰来吃了。（激素）”乙:“怪不得！我那儿媳妇刚过门才一个礼拜这都快生了！”（……）','a340dd2dda7b70ac76d3cc3b43eda6f2',69,37),(8,8,'2013-09-26 08:18:52','和前面一看书妹妹等公交，上车后妹纸边看书边拿一元钱在刷卡机蹭了一下装其囗袋，我在后面笑喷了，心想这二货，然后我隨手把卡投进了投币机里...','a2de971ee2cfbd05fd10e3f079c4d76c',2,2),(9,9,'2013-09-26 21:25:16','一老师在上课时说“在我的字典里就没有“失败”两个字”结果从下面传来一本字典。小新同学说了一句“老师我的字典借你”','eb1908cb6cc7c14ffa02a18a052710e9',2,5),(10,2,'10-11 21:15','银不吐槽枉骚年。。。','b8cdbfe338b1dd1a1da5e1c42b5c4904',15,18),(11,3,'10-11 21:20','网页版测试。。。','64fb1688e192c2a5bb6716653f5dbab6',0,1),(13,2,'10-11 21:55','银不吐槽枉骚年。。。我是楼主.....','3ae66297ebfa18ab18292d9ce3b2c8a8',0,0),(14,2,'10-11 22:04','银不吐槽枉骚年。。。','b8cdbfe338b1dd1a1da5e1c42b5c4904',15,18),(15,3,'10-24 23:22','xcvzdsc','919437236f8e47be9c2b373ee9cadd8c',0,1),(16,24,'10-25 08:06','姐年轻怎么滴........................','654707c579b1731cb7481fb804a9f2e6',4,0),(17,13,'11-01 23:24','银不吐槽枉骚年。。。','b8cdbfe338b1dd1a1da5e1c42b5c4904',7,2),(18,22,'11-09 21:10','银不吐槽枉骚年。。。','b8cdbfe338b1dd1a1da5e1c42b5c4904',7,1),(19,1,'11-11 22:10','银不吐槽枉骚年。。。','b8cdbfe338b1dd1a1da5e1c42b5c4904',0,0),(20,1,'11-11 22:12','Yuw更好','80072d85573b5a0e6632984191a894bd',0,0);
/*!40000 ALTER TABLE `butubukuai_neihanarticle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `butubukuai_nhartcomment`
--

DROP TABLE IF EXISTS `butubukuai_nhartcomment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_nhartcomment` (
  `floor` int(11) NOT NULL,
  `Pmd5code` varchar(50) NOT NULL,
  `discuss` text,
  `observer` varchar(50) NOT NULL,
  `date` varchar(45) DEFAULT NULL,
  `praisenumber` int(11) DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_nhartcomment`
--

LOCK TABLES `butubukuai_nhartcomment` WRITE;
/*!40000 ALTER TABLE `butubukuai_nhartcomment` DISABLE KEYS */;
INSERT INTO `butubukuai_nhartcomment` VALUES (1,'cxvxcvxcv1','新的评论','sdaf','12-21 09:23',2,1),(1,'dsafgasd2','看来你女盆友不喜欢这里的菜啊！','不吐槽会死星人','12-12 12:23',284,2),(2,'cxvxcvxcv1','大爷那个过肩龙碉堡了！','刘德华','09-27 19:16',13,3),(3,'cxvxcvxcv1','去瑞士滑雪，一下飞机，头一口气就呛晕菜了。丫空气太纯了，醉氧！急救车一到，拼着命冲大夫比划：拆那！大夫立马明白：OK！把氧气袋放掉，接了袋汽车尾气，插上管，然后直接送回飞机。等飞机在首都机场一落地，舱门一开，一闻，哇靠，味儿真正！呼吸舒畅浑身通泰，好啦！”','刘德华','09-27 19:17',1,4),(2,'dsafgasd2','上小学时老师让写一篇关于做家务的作文，反复强调要真实。周一老师让一同学读，他读到：回家后我要帮妈妈洗衣服，妈妈说滚一边玩去，我说老师让我做的，我妈说你们老师逼事儿真多……','王长超','09-27 19:18',0,5),(3,'aaa','杭州大雨，街上水很深。一打伞的哥们站在没过膝盖的水中发愁。这时一开路虎的大哥用藐视的目光看了看他，加大油门冲了过去，结果整车全部淹的都看不见顶了。车主好不容易从水里游上来对打伞的哥们说：大哥水不是才到你膝盖吗？打伞的哥们回答：爷是站在我的宾利车顶上呢！','刘德华','09-27 06:22',0,6),(1,'a340dd2dda7b70ac76d3cc3b43eda6f2','高级数学题：什么叫通货膨胀?\" 求证：1元=1分 解：1元=100分 =10分×10分 =1角 ×1角 =0.1元×0.1元 =0.01元 =1分 证明完毕。','zsdfg的双丰收的','09-27 06:22',0,7),(2,'dfgsdf','一名狱警对犯人说:”你老婆来看你了。” 犯人问:她叫什么名字？” 狱警察不耐烦了，说:”你能不知道自己老婆的名字？” 犯人:”我犯的是重婚罪。”','zsdfg的双丰收的','09-27 06:22',0,8),(3,'dfgsdf','中国人.日本人还有美国人一起再森林里探险.突然出现一条毒蛇.分别在他们身上咬了一口！最后最后美国人死了.日本人死了.蛇夜死了！懂的请按右上角','zsdfg的双丰收的','09-27 06:22',0,9),(4,'aaa','中国人.日本人还有美国人一起再森林里探险.突然出现一条毒蛇.分别在他们身上咬了一口！最后最后美国人死了.日本人死了.蛇夜死了！懂的请按右上角','刘德华','09-27 06:29',0,10),(5,'aaa','乖女儿，爸爸问你，世上有没有一个消息里同时包含了好消息和坏消息？” “有啊，我不是你亲女儿！”','王尼玛','09-27 06:31',0,11),(6,'aaa','你好这是我得评论','刘德华','09-27 06:32',0,12),(1,'dszfg3','土豪求交往.','李兴乐','10-12 00:38',0,13),(2,'dszfg3','二楼傻逼哈哈.....','李兴乐','10-12 00:40',0,14),(3,'dszfg3','二楼又亮了。','李兴乐','10-12 00:42',0,15),(4,'dszfg3','我等iphone6吧。','李兴乐','10-12 00:44',0,16),(1,'asfgrts6','抢沙发','李兴乐','10-12 00:46',0,17),(2,'asfgrts6','抢你妹','李兴乐','10-12 00:48',0,18),(1,'dsfgsdfgdsfg5','终于抢到了.','李兴乐','10-12 00:51',0,19),(1,'dfgdsfg4','说曹操曹操到啊.','李兴乐','10-12 00:52',0,20),(1,'eb1908cb6cc7c14ffa02a18a052710e9','小新好萌','李兴乐','10-12 00:55',0,21),(1,'445379213c8e82650eae478ef5f891f6','添加评论.','李兴乐','10-12 03:21',0,22),(1,'b8cdbfe338b1dd1a1da5e1c42b5c4904','银不吐槽枉骚年。。。','李兴乐','10-14 07:56',0,23),(1,'60','测试评论','李兴乐','10-24 08:10',0,24),(2,'dsfgsdfgdsfg5','二楼','王尼玛','10-24 23:22',0,25),(3,'dsfgsdfgdsfg5','鱼丸','lixingle','11-11 22:30',0,26);
/*!40000 ALTER TABLE `butubukuai_nhartcomment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `butubukuai_poetry`
--

DROP TABLE IF EXISTS `butubukuai_poetry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_poetry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `date` varchar(45) NOT NULL,
  `article` text NOT NULL,
  `md5code` varchar(45) NOT NULL,
  `praisenumber` int(11) DEFAULT '0',
  `badnumber` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_poetry`
--

LOCK TABLES `butubukuai_poetry` WRITE;
/*!40000 ALTER TABLE `butubukuai_poetry` DISABLE KEYS */;
INSERT INTO `butubukuai_poetry` VALUES (1,1,'09-12 13:21','天王盖地虎','asgfadfsgfdsgeer',1,3),(2,2,'10-15 17:03','风声雨声读书声声声入耳','asfgrts',1,8),(3,5,'10-15 17:05','昨夜西风凋碧树','asfgrtsdszgs',2,2),(4,3,'10-15 04:27','春眠不觉晓','5d1543565e95d0fbc49386d4873b16d3',5,11),(5,2,'10-15 07:05','银不吐槽枉骚年。。。','b8cdbfe338b1dd1a1da5e1c42b5c4904',10,7),(6,2,'10-15 07:08','吃葡萄不吐葡萄批','8f3af5c44649a00d536ab4f9c386eb05',1,3),(7,22,'10-30 23:06','添加绝对投稿.','095caade40e2ec6485f1e907296a85da',0,0);
/*!40000 ALTER TABLE `butubukuai_poetry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `butubukuai_poetrycomment`
--

DROP TABLE IF EXISTS `butubukuai_poetrycomment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_poetrycomment` (
  `floor` int(11) NOT NULL,
  `Pmd5code` varchar(45) NOT NULL,
  `discuss` text NOT NULL,
  `observer` varchar(45) DEFAULT NULL,
  `date` varchar(45) DEFAULT NULL,
  `praisenumber` int(11) DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_poetrycomment`
--

LOCK TABLES `butubukuai_poetrycomment` WRITE;
/*!40000 ALTER TABLE `butubukuai_poetrycomment` DISABLE KEYS */;
INSERT INTO `butubukuai_poetrycomment` VALUES (1,'asgfadfsgfdsgeer','第一条评论','李兴乐','10-15 07:45',0,11),(1,'b8cdbfe338b1dd1a1da5e1c42b5c4904','第二条','李兴乐','10-15 07:45',0,12),(2,'b8cdbfe338b1dd1a1da5e1c42b5c4904','测试添加评论','李兴乐','10-15 08:09',0,13),(1,'5d1543565e95d0fbc49386d4873b16d3','蚊子到处跑.','李兴乐','10-23 04:48',0,14),(1,'asfgrts','家事国事天下事事事关心','李兴乐','10-24 03:30',0,15),(1,'8f3af5c44649a00d536ab4f9c386eb05','银不吐槽枉骚年。。。','王尼玛','10-25 00:02',0,16),(2,'5d1543565e95d0fbc49386d4873b16d3','读书就困了','气死你气死你七四七四七死你','10-25 08:02',0,17),(2,'asgfadfsgfdsgeer','小鸡炖蘑菇','王尼玛','10-30 08:12',0,18),(3,'5d1543565e95d0fbc49386d4873b16d3','处处闻啼鸟......','lixingle','11-13 04:57',0,19),(4,'5d1543565e95d0fbc49386d4873b16d3','处处','lixingle','11-13 05:00',0,20),(5,'5d1543565e95d0fbc49386d4873b16d3','幸福感和行动','李兴乐','11-13 05:20',0,21);
/*!40000 ALTER TABLE `butubukuai_poetrycomment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `butubukuai_user`
--

DROP TABLE IF EXISTS `butubukuai_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `butubukuai_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `grade` varchar(45) NOT NULL,
  `headerimage` varchar(200) NOT NULL DEFAULT 'headerimage/header.jpeg',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `butubukuai_user`
--

LOCK TABLES `butubukuai_user` WRITE;
/*!40000 ALTER TABLE `butubukuai_user` DISABLE KEYS */;
INSERT INTO `butubukuai_user` VALUES (1,'lixingle','123','菜鸟','headerimage/201311121225324930.png'),(2,'不吐不快','123','初级','headerimage/mantou.jpg'),(3,'王尼玛','123','大师','headerimage/201310302123174620.png'),(4,'乐不思书','123','特级大师','headerimage/mantou.jpg'),(5,'不吐槽会死星人','123','小白','headerimage/header2.jpg'),(6,'二不二你知道','123','特级大师','headerimage/header2_1.jpg'),(7,'乐仔','123','菜鸟','headerimage/77181312766490.jpeg'),(8,'神吐槽','123','小白','headerimage/1b8f_beautiful-iphone-wallpaper-3.jpg'),(9,'逗你玩','123','新手','headerimage/666661.png'),(10,'lovecc','123','菜鸟','headerimage/images_8.jpeg'),(11,'刘德华','123','cainiao','headerimage/1_2.jpeg'),(12,'lixinglewcc','123','菜鸟','headerimage/1b8f_beautiful-iphone-wallpaper-3.jpg'),(13,'李兴乐','123','菜鸟','headerimage/1_5.jpeg'),(14,'李二狗','123','菜鸟','headerimage/1_1.jpeg'),(22,'王长超','123','菜鸟','headerimage/201310302125122240.png'),(23,'气死你气死你七四七四七死你','123','菜鸟','headerimage/header.jpeg'),(24,'cc','123','菜鸟','headerimage/header.jpeg'),(25,'wildcat','123','菜鸟','headerimage/header.jpeg'),(26,'李兴隆','123','菜鸟','headerimage/header.jpeg');
/*!40000 ALTER TABLE `butubukuai_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_NHImageComment`
--

DROP TABLE IF EXISTS `myapp_NHImageComment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `myapp_NHImageComment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `floor` int(11) DEFAULT NULL,
  `pid` int(11) NOT NULL DEFAULT '0',
  `discuss` text NOT NULL,
  `observer` varchar(60) NOT NULL,
  `date` varchar(50) DEFAULT NULL,
  `praisenumber` int(11) DEFAULT '0',
  PRIMARY KEY (`id`,`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_NHImageComment`
--

LOCK TABLES `myapp_NHImageComment` WRITE;
/*!40000 ALTER TABLE `myapp_NHImageComment` DISABLE KEYS */;
INSERT INTO `myapp_NHImageComment` VALUES (1,1,58,'好好好','李兴乐','10-24 19:52',0),(2,1,63,'好好好','兴乐','10-24 19:55',137),(3,1,59,'好好好','李兴乐','10-24 19:53',1),(4,1,62,'好好好','兴乐','10-24 19:54',0),(5,2,58,'不错','刘德华','10-24 07:11',0),(6,1,52,'不错','刘德华','10-24 07:11',0),(7,3,58,'不错delegate','刘德华','10-24 07:12',0),(8,1,1,'不错delegate','刘德华','10-24 07:12',0),(9,2,1,'不错delegate','刘德华','10-24 07:29',0),(10,1,61,'不错delegate','刘德华','10-24 07:30',0),(11,2,61,'老板来两金香蕉.','李兴乐','10-24 08:14',0),(12,1,64,'近在咫尺','李兴乐','10-24 08:14',0),(13,2,64,'哈哈成功','李兴乐','10-24 08:15',0),(14,1,56,'女汉子','李兴乐','10-24 21:05',0),(15,2,56,'抢沙发','李兴乐','10-24 21:05',0),(16,1,60,'同时天涯苦命人啊','李兴乐','10-24 21:35',0),(17,2,59,'同感啊','王长超','10-25 04:00',0),(18,2,60,'嘿嘿7417417474741','气死你气死你七四七四七死你','10-25 07:58',0);
/*!40000 ALTER TABLE `myapp_NHImageComment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_document`
--

DROP TABLE IF EXISTS `myapp_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `myapp_document` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `docfile` varchar(500) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `date` varchar(45) NOT NULL,
  `article` text,
  `praisenumber` int(11) DEFAULT '0',
  `badnumber` int(11) DEFAULT '0',
  `imagewidth` double DEFAULT NULL,
  `imageheight` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_document`
--

LOCK TABLES `myapp_document` WRITE;
/*!40000 ALTER TABLE `myapp_document` DISABLE KEYS */;
INSERT INTO `myapp_document` VALUES (1,'documents/2013/10/25/201310251912490260.png','王长超','10-25 06:13','樱桃',3,3,255,383),(56,'documents/2013/10/24/201310241739598810.png','lixingle','10-24 04:40','好狠心啊',5,6,280,429),(58,'documents/2013/10/24/201310241741525820.png','李兴乐','10-24 04:42','这孩子将来必成大气',5,5,280,358),(59,'documents/2013/10/24/201310241820256770.png','王长超','10-24 05:20','这是不是真的.',6,1,280,230),(60,'documents/2013/10/24/201310241820570690.png','王长超','10-24 05:21','支持老太太...',7,6,280,174),(61,'documents/2013/10/24/201310241828092070.png','王长超','10-24 05:29','老板说 生意不好做啊 还得动脑子 有图有真相',3,3,280,498),(62,'documents/2013/10/24/201310241832153020.png','lixinglewcc','10-24 05:33','断句之美，总是如此感伤……',4,0,280,498),(63,'documents/2013/10/24/201310241842454390.png','lixinglewcc','10-24 05:42','我们办公室鼠标用到最后只能这样用了。。。',4,136,280,158),(64,'documents/2013/10/24/201310242104237460.png','lixinglewcc','10-24 08:04','不吐不快图表.',3,0,280,275),(67,'documents/2013/10/25/201310251629262820.png','王长超','10-25 03:29','王尼玛的馒头哈哈大笑',3,3,256,256),(70,'documents/2013/10/25/201310251636460700.png','王长超','10-25 03:36','爱心',3,0,255,255),(71,'documents/2013/10/25/201310251637057500.png','王长超','10-25 03:37','gif',3,1,255,159),(72,'documents/2013/10/30/201310302029437580.png','王尼玛','10-30 07:29','这孩子委屈了.',3,0,255,340),(73,'documents/2013/11/11/201311121223592580.png','lixingle','11-11 22:24','太阳',3,0,255,251);
/*!40000 ALTER TABLE `myapp_document` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-11-13 19:50:20
