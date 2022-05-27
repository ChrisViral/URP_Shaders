#ifndef SHAPES
#define SHAPES

void circle_float(float2 pos, float2 center, float radius, out float result)
{
    float len = length(pos - center);
    float halfWidth = radius / 20;
    float edge = halfWidth / 10;
    result = smoothstep(radius - halfWidth - edge, radius - halfWidth,        len)
           - smoothstep(radius + halfWidth,        radius + halfWidth + edge, len);
}

void onLine_float(float a, float b, float width, out float result)
{
    float halfLine = width / 2;
    float edge = halfLine / 10;
    result = smoothstep(a - halfLine - edge, a - halfLine, b)
           - smoothstep(a + halfLine, a + halfLine + edge, b);
}

void cross_float(float2 pos, float2 center, float length, out float result)
{
    pos -= center;
    if (pos.x > length || pos.x < -length || pos.y > length || pos.y < -length)
    {
        result = 0;
        return;
    }

    float horizontal;
    float vertical;
    float width = length / 10;
    onLine_float(pos.x, 0, width, horizontal);
    onLine_float(pos.y, 0, width, vertical);
    result = saturate(horizontal + vertical);
}
#endif
