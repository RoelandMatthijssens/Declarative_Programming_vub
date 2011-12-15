from Tkinter import *
from nodes import *
from edges import *
def draw_point(x, y, CANVAS):
	CANVAS.create_oval(x*24+5, y*12+5, x*24+5, y*12+5, width=1, fill='red')

def draw_x(node, CANVAS):
    x=node[1]*24+5
    y=node[2]*12+5
    CANVAS.create_line(x+3, y+3, x-3, y-3)
    CANVAS.create_line(x-3, y+3, x+3, y-3)

def draw_edge(edge, nodes, CANVAS):
    node1=nodes[edge[0]]
    node2=nodes[edge[1]]
    CANVAS.create_line(node1[1]*24+5, node1[2]*12+5, node2[1]*24+5, node2[2]*12+5)
    draw_x(node2, CANVAS)

def main(node_list, edge_list, CANVAS):
    for node in node_list:
        draw_point(node[1], node[2], CANVAS)
    for edge in edge_list:
        draw_edge(edge, node_list, CANVAS)

def create_canvas():
	CANVAS=Canvas(width=300, height=300, bg='white')
	CANVAS.pack(expand=YES, fill=BOTH)
	return CANVAS

x = create_canvas()
main(nodes, edges, x)
