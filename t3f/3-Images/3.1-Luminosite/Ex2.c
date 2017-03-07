#include <SDL/SDL.h>
#include <stdio.h>

unsigned int largeur = 320;
unsigned int hauteur = 240;
unsigned int couleurs = 32;
unsigned char quitter = 0;
int offset_luminosite = 0;
Uint8 alpha = 0;
SDL_Surface *image_displayed = NULL;
SDL_Surface *image_source = NULL;

SDL_Surface *loadBMP(char *fileName)
{
    SDL_Surface *tmp;
    SDL_Surface *image;

    tmp = SDL_LoadBMP(fileName);
    if(tmp == NULL)
    {
        fprintf(stderr, "Could not load %s : %s\n", fileName, SDL_GetError());
        return NULL;
    }
    image = SDL_CreateRGBSurface(0, tmp->w, tmp->h, 32, 0, 0, 0, 0);
    if(image == NULL)
    {
        fprintf(stderr, "Could not load %s : %s\n", fileName, SDL_GetError());
        return NULL;
    }
    SDL_BlitSurface(tmp, NULL, image, NULL);
    SDL_FreeSurface(tmp);

    return image;
}

static void handle_key_down(SDL_keysym* keysym)
{
    switch(keysym->sym)
    {
        case SDLK_ESCAPE:
            quitter = 1;
            break;
        case SDLK_a:
            offset_luminosite += 5;
            break;
        case SDLK_q:
            offset_luminosite -= 5;
            break;
        case SDLK_p:
            alpha += 5;
            printf("Alpha: %u\n", alpha);
            break;
        case SDLK_m:
            alpha -= 5;
            printf("Alpha: %u\n", alpha);
            break;
        default:
            break;
    }
}

void show_pixel(SDL_Surface *img, Sint32 x, Sint32 y)
{
    Uint8 *p = (Uint8*) img->pixels + y*img->pitch + x*img->format->BytesPerPixel;
    Uint32 a = (Uint32) p[3];
    Uint32 r = (Uint32) p[2];
    Uint32 g = (Uint32) p[1];
    Uint32 b = (Uint32) p[0];
    printf("Pixel (%u, %u): RGBA = %u - %u - %u - %u\n", x, y, r, g, b, a);
}

static void process_events(void)
{
    SDL_Event event;
    while(SDL_PollEvent(&event))
    {
        switch(event.type)
        {
            case SDL_KEYDOWN:
                handle_key_down(&event.key.keysym);
                break;
            case SDL_MOUSEBUTTONDOWN:
                if(event.button.button == SDL_BUTTON_LEFT && event.button.state == SDL_PRESSED)
                {
                    show_pixel(image_displayed, event.button.x, event.button.y);
                    show_pixel(image_source, event.button.x, event.button.y);
                }
                break;
            case SDL_QUIT:
                quitter = 1;
                break;
        }
    }
}

SDL_Surface* convertBW(SDL_Surface *image)
{
    SDL_Surface* tmp = SDL_CreateRGBSurface(0, image->w, image->h, 32, 0, 0, 0, 0);
    SDL_BlitSurface(image, NULL, tmp, NULL);
    for(int x = 0; x < image->w; ++x)
    {
        for(int y = 0; y < image->h; ++y)
        {
            Uint8 *p = (Uint8*) tmp->pixels + y*tmp->pitch + x*tmp->format->BytesPerPixel;
            Uint32 n = ((Uint32) p[0] + (Uint32) p[1] + (Uint32) p[2] + (Uint32) p[3]) / 3;
            *(Uint32 *)p = (n << 16) + (n << 8) + n;
        }
    }
    return tmp;
}

SDL_Surface* adapte_luminositeBW(SDL_Surface *image)
{
    SDL_Surface* tmp = SDL_CreateRGBSurface(0, image->w, image->h, 32, 0, 0, 0, 0);
    SDL_BlitSurface(image, NULL, tmp, NULL);
    for(int x = 0; x < image->w; ++x)
    {
        for(int y = 0; y < image->h; ++y)
        {
            Uint8 *p = (Uint8*) tmp->pixels + y*tmp->pitch + x*tmp->format->BytesPerPixel;
            Uint32 n = ((Uint32) p[0] + (Uint32) p[1] + (Uint32) p[2] + (Uint32) p[3]) / 4;
            if(offset_luminosite > 0 || n > -offset_luminosite)
            {
                n = n + offset_luminosite;
                if(n > 255) 
                    n = 255;
            }
            else
                n = 0;
            *(Uint32 *)p = (n << 16) + (n << 8) + n;
        }
    }
    return tmp;
}

SDL_Surface* adapte_luminosite(SDL_Surface *image)
{
    SDL_Surface* tmp = SDL_CreateRGBSurface(0, image->w, image->h, 32, 0, 0, 0, 0);
    SDL_BlitSurface(image, NULL, tmp, NULL);
    for(int x = 0; x < image->w; ++x)
    {
        for(int y = 0; y < image->h; ++y)
        {
            Uint8 *p = (Uint8*) tmp->pixels + y*tmp->pitch + x*tmp->format->BytesPerPixel;
            Uint32 a = (Uint32) p[3];
            Uint32 r = (Uint32) p[2];
            Uint32 g = (Uint32) p[1];
            Uint32 b = (Uint32) p[0];
            if(offset_luminosite >= 0 || r > -offset_luminosite)
            {
                r = r + offset_luminosite;
                if(r > 255) 
                    r = 255;
            }
            else
                r = 0;
            if(offset_luminosite >= 0 || g > -offset_luminosite)
            {
                g = g + offset_luminosite;
                if(g > 255) 
                    g = 255;
            }
            else
                g = 0;
            if(offset_luminosite >= 0 || b > -offset_luminosite)
            {
                b = b + offset_luminosite;
                if(b > 255) 
                    b = 255;
            }
            else
                b = 0;
            *(Uint32 *)p = (alpha << 24) + (r << 16) + (g << 8) + b;
        }
    }
    //return tmp;

    SDL_Surface *result = SDL_CreateRGBSurface(0, image->w, image->h, 32, 0, 0, 0, 0);
    SDL_FillRect(result, NULL, SDL_MapRGB(result->format, 0, 0, 0));
    SDL_Rect whiteRect;
    whiteRect.x = 100;
    whiteRect.y = 100;
    whiteRect.w = 100;
    whiteRect.h = 100;
    SDL_FillRect(result, &whiteRect, SDL_MapRGB(result->format, 255, 255, 255));
    SDL_BlitSurface(tmp, NULL, result, NULL);
    return result;
}

int main(int argc, char *argv[], char *env[])
{
    if(argc==2)
    {
        SDL_Surface *screen;
        if(SDL_Init(SDL_INIT_VIDEO) < 0)
        {
            fprintf(stderr, "Could not initialize SDL : %s.\n", SDL_GetError());
            return -1;
        }

        screen = SDL_SetVideoMode(largeur, hauteur, couleurs, SDL_SWSURFACE | SDL_ANYFORMAT);

        if(screen == NULL)
        {
            fprintf(stderr, "Could not set %ux%ux%u video mode : %s.\n", largeur, hauteur, couleurs, SDL_GetError());
            SDL_Quit();
            return -1;
        }

        image_source = loadBMP(argv[1]);
        if(image_source == NULL)
        {
            SDL_Quit();
            return -1;
        }

        SDL_Surface *imageBW;
        imageBW = convertBW(image_source);

        uint32_t begin;
        while(!quitter)
        {
            SDL_FillRect(screen, NULL, SDL_MapRGB(screen->format, 0, 0, 0));
            SDL_Rect whiteRect;
            whiteRect.x = 100;
            whiteRect.y = 100;
            whiteRect.w = 100;
            whiteRect.h = 100;
            SDL_FillRect(screen, &whiteRect, SDL_MapRGB(screen->format, 255, 255, 255));
            begin = SDL_GetTicks();
            image_displayed = adapte_luminosite(imageBW);
            process_events();
            //printf("%u - %i\n", SDL_GetTicks() - begin, offset_luminosite);
            if(SDL_BlitSurface(image_displayed, NULL, screen, NULL) < 0)
                fprintf(stderr, "BlitSurface error : %s\n", SDL_GetError());

            //SDL_BlitSurface(imageBW, NULL, screen, NULL);
            //SDL_UpdateRect(screen, 0, 0, imageBW->w, imageBW->h);
            SDL_Flip(screen);
            SDL_FreeSurface(image_displayed);
        }

        SDL_FreeSurface(imageBW);
        //SDL_FreeSurface(image_source);

        SDL_Quit();
        return 0;
    }
    else
    {
        fprintf(stderr, "Syntaxe : Ex2 <imagename>\n");
        return 0;
    }
}
