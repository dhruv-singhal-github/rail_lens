import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

class domainimage
{

  var imagename;
  var sno;
  var date;

domainimage({this.imagename,this.sno,this.date});



  factory domainimage.fromJson(Map<String, dynamic> json) {
    return domainimage(
        imagename: json['imgname'],
        sno: json['sno'],
        date: json['photodate']
    );
  }

}