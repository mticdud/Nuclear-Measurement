function [a1,b1,c1,d1,e1,f1,g1,h1] = empty_objs_combo(a,b,c,d,e,f,g,h)
%Function for Nuclear_Measure_GUI for determining empty structures created
%for slider/plot interactions. Check if data objects are empty or not.
%a,b,c,d,e,f,g,h are GUI objects corresponding to the pushbuttons in
%descending order
if isempty(a) == 0
    a1 = 1;
end
if isempty(b) == 0
    b1 = 1;
end
if isempty(c) == 0
    c1 = 1;
end
if isempty(d) == 0
    d1 = 1;
end
if isempty(e) == 0
    e1 = 1;
end
if isempty(f) == 0
    f1 = 1;
end
if isempty(g) == 0
    g1 = 1;
end
if isempty(h) == 0
    h1 = 1;
end
end

