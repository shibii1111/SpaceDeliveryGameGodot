# That global constant is going to help keep the whole project clean.
# Godot likes to reference other scenes everywhere to do a lot of things.
# By doing that we can call Constant.Scenes.Player for example.
# Inspired by https://www.youtube.com/watch?v=acNQIBBIpQk

extends Node

const PLAYER_SCENE: PackedScene = preload("uid://dkqg1dfl6ybdm")
