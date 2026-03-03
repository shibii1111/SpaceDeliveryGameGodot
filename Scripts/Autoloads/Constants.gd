# That global constant is going to help keep the whole project clean.
# Godot likes to reference other scenes everywhere to do a lot of things.
# By doing that we can call Constant.Scenes.Player for example.
# Inspired by https://www.youtube.com/watch?v=acNQIBBIpQk

extends Node

class Scenes:
	const PLAYER: PackedScene = preload("uid://dkqg1dfl6ybdm")
	const LOADING_SCREEN: PackedScene = preload("uid://cqx25emxcu721")

class Projectiles:
	const NORMAL: PackedScene = preload("uid://b4v1cem220w0t")
	const HOMING: PackedScene = preload("uid://bvu5cyn5o3noa")
