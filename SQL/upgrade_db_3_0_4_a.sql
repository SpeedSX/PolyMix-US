яю/ * * * * * *   O b j e c t :     S t o r e d P r o c e d u r e   [ d b o ] . [ u p _ S e t u p U s e r R o l e s ]         S c r i p t   D a t e :   7 / 3 / 2 0 2 2   8 : 4 3 : 5 2   P M   * * * * * * /  
 S E T   A N S I _ N U L L S   O N  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O N  
 G O  
  
  
 A L T E R                   p r o c e d u r e   [ d b o ] . [ u p _ S e t u p U s e r R o l e s ]  
 a s    
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   s y s u s e r s   w h e r e   n a m e   =   ' p o w e r _ u s e r ' )  
     d e n y   a l l   t o   p o w e r _ u s e r  
 e l s e  
     e x e c   s p _ a d d r o l e   ' p o w e r _ u s e r '  
  
 i f   e x i s t s   ( s e l e c t   *   f r o m   s y s u s e r s   w h e r e   n a m e   =   ' j u s t _ u s e r ' )  
     d e n y   a l l   t o   j u s t _ u s e r  
 e l s e  
     e x e c   s p _ a d d r o l e   ' j u s t _ u s e r '  
  
 - -   P O W E R _ U S E R  
 g r a n t   s e l e c t   o n   W o r k O r d e r   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t   o n   W o r k O r d e r I t e m   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e   o n   C u s t o m e r   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   P e r s o n s   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   _ C o d e   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   _ F o r m a t s   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   _ T y p e s   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   C o m m o n E x p e n s e s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c E l e m e n t s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c F o l d e r s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c F i e l d s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D o l l a r   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   G l o b a l S c r i p t s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   O r d e r P a r a m s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   O r d e r S c r i p t s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S c r i p t e d F o r m s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S e r v i c e s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v F i e l d s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v G r i d C o l u m n s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v G r o u p s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v P a g e s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v S c r i p t I n f o   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v V F i e l d s   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   U s e r I P   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   W o r k L o c k   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   P o l y C a l c V e r s i o n   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   d e l e t e   o n   O r d e r P r o c e s s I t e m   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   J o b   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   O r d e r P r o c e s s I t e m M a t e r i a l   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i s p l a y I n f o   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   C u s t o m R e p o r t s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   C u s t o m R e p o r t C o l u m n s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   E n t e r p r i s e S e t t i n g s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   G l o b a l H i s t o r y   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   O r d e r H i s t o r y   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   C o n t r a g e n t H i s t o r y   t o   p o w e r _ u s e r  
 - - g r a n t   s e l e c t   o n   D i c _ D u m m y I n t   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   A c c e s s U s e r   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   A c c e s s K i n d   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   A c c e s s K i n d P r o c e s s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   P r o c e s s G r i d s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   K i n d O r d e r   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   K i n d P r o c e s s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   O r d e r P r o c e s s I t e m J o b s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t   o n   C u s t o m e r I n c o m e   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   L a s t S t a t e C h a n g e D a t e   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   I n v o i c e I t e m P a y m e n t s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   E m p l o y e e T o E q u i p S h i f t   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   E m p l o y e e T o D e p a r t m e n t S h i f t   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   i n s e r t ,   d e l e t e   o n   A d d r e s s e s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   I n v o i c e s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   I n v o i c e I t e m s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   P a y m e n t s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e   o n   S h i p m e n t   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   u p d a t e   o n   S h i p m e n t D o c   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   d e l e t e   o n   O r d e r A t t a c h e d F i l e s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   i n s e r t ,   u p d a t e ,   d e l e t e   o n   O r d e r N o t e s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   E n a b l e d M i x   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   S t o c k M o v e   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   S t o c k M o v e P r o c e s s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   S t o c k I n c o m e D o c   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   S t o c k I n c o m e I t e m   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   A l i v e W o r k O r d e r s   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t   o n   O b j e c t L o c k   t o   p o w e r _ u s e r  
 g r a n t   s e l e c t ,   i n s e r t ,   d e l e t e   o n   R e l a t e d C o n t r a g e n t s   t o   p o w e r _ u s e r  
  
 - -   "01;8FK  ?@>F5AA>2 
  
 d e c l a r e   @ O K   i n t  
 d e c l a r e   @ S r v I D   i n t ,   @ S r v N a m e   s y s n a m e ,   @ n s   n v a r c h a r ( 5 0 0 )  
 d e c l a r e   S r v C u r s o r   c u r s o r   l o c a l   f o r  
         s e l e c t   S r v I D ,   S r v N a m e   f r o m   S e r v i c e s  
 o p e n   S r v C u r s o r  
 f e t c h   n e x t   f r o m   S r v C u r s o r  
 i n t o   @ S r v I D ,   @ S r v N a m e  
 s e t   @ O K   =   0  
 W H I L E   @ @ F E T C H _ S T A T U S   =   0   a n d   @ O K   < >   - 3  
 B E G I N  
         i f   e x i s t s   ( s e l e c t   *   f r o m   s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' S e r v i c e _ '   +   @ S r v N a m e )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s T a b l e ' )   =   1 )   b e g i n  
             s e t   @ n s   =   N ' g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S e r v i c e _ '   +   @ S r v N a m e   +   N '   t o   p o w e r _ u s e r '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             i f   @ @ E R R O R   < >   0   s e t   @ O K   =   - 3  
         e n d  
         f e t c h   n e x t   f r o m   S r v C u r s o r  
         i n t o   @ S r v I D ,   @ S r v N a m e  
 E N D  
 c l o s e   S r v C u r s o r  
 d e a l l o c a t e   S r v C u r s o r  
  
 - -   "01;8FK  A?@02>G=8:>2 
 d e c l a r e   @ M u l t i D i m   b i t  
 d e c l a r e   D i c C u r s o r   c u r s o r   l o c a l   f o r  
         s e l e c t   D i c I D ,   D i c N a m e ,   M u l t i D i m   f r o m   D i c E l e m e n t s  
 o p e n   D i c C u r s o r  
 f e t c h   n e x t   f r o m   D i c C u r s o r  
 i n t o   @ S r v I D ,   @ S r v N a m e ,   @ M u l t i D i m  
 s e t   @ O K   =   0  
 W H I L E   @ @ F E T C H _ S T A T U S   =   0   a n d   @ O K   < >   - 3  
 B E G I N  
         i f   e x i s t s   ( s e l e c t   *   f r o m   s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' D i c _ '   +   @ S r v N a m e )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s T a b l e ' )   =   1 )   b e g i n  
             s e t   @ n s   =   N ' g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c _ '   +   @ S r v N a m e   +   N '   t o   p o w e r _ u s e r '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             i f   @ @ E R R O R   < >   0   s e t   @ O K   =   - 3  
             i f   ( @ M u l t i D i m   =   1 )   a n d   e x i s t s   ( s e l e c t   *   f r o m   s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' D i c M u l t i _ '   +   @ S r v N a m e )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s T a b l e ' )   =   1 )   b e g i n  
                 s e t   @ n s   =   N ' g r a n t   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c M u l t i _ '   +   @ S r v N a m e   +   N '   t o   p o w e r _ u s e r '  
                 e x e c   s p _ e x e c u t e s q l   @ n s  
             e n d  
         e n d  
         f e t c h   n e x t   f r o m   D i c C u r s o r  
         i n t o   @ S r v I D ,   @ S r v N a m e ,   @ M u l t i D i m  
 E N D  
 c l o s e   D i c C u r s o r  
 d e a l l o c a t e   D i c C u r s o r  
  
 - - g r a n t   e x e c u t e   o n   u p _ A d d U s e r I P   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ C l e a r U s e r I P   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ C o m E x p T o U S D   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e D i c t i o n a r y   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ D e l e t e O r d e r I t e m   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e S e r v i c e   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ D e l O r d e r I t e m D e p e n d e n t   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ D e l U s e r I P   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l S r v G r o u p   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w S e r v i c e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w S r v G r o u p   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w T a b l e D i c t i o n a r y   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ N e w W o r k C u s t o m e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ U p d a t e T a b l e D i c t i o n a r y   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ G e t O r d e r N u m b e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ C h a n g e O r d e r S t a t u s   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w O r d e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ E m e r g e n c y N e w O r d e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ U p d a t e O r d e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ S e t O r d e r O w n e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ C h a n g e O r d e r S t a t e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ C o p y O r d e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ C o p y O r d e r 2   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l O r d e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ P u r g e A l l   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ P u r g e O r d e r   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ R e s t o r e O r d e r   t o   p o w e r _ u s e r  
  
 - - g r a n t   e x e c u t e   o n   u p _ I s O r d e r R o w L o c k e d   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ S e t O r d e r L o c k   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ D e l O r d e r L o c k   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ I s O b j e c t L o c k e d   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ S e t O b j e c t L o c k   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ R e m o v e O b j e c t L o c k   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ R e m o v e U s e r L o c k s   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ R e m o v e C l a s s L o c k   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ N e w O r d e r A t t a c h e d F i l e   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ N e w O r d e r P r o c e s s I t e m   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ U p d a t e O r d e r P r o c e s s I t e m   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ U p d a t e O r d e r P r o c e s s I t e m 2   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e O r d e r P r o c e s s I t e m   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w S p e c i a l J o b   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w P r o c e s s J o b   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e J o b   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ U n P l a n J o b   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ U n P l a n I t e m   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ R e n u m b e r S p l i t P a r t s I t e m   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ R e n u m b e r S p l i t P a r t s J o b   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ C o p y A c c e s s U s e r   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ G e t N o N a m e K e y   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e C o n t r a g e n t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w C o n t r a g e n t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ P u r g e C o n t r a g e n t   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ A d d P a y m e n t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w C u s t o m e r I n c o m e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e C u s t o m e r I n c o m e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ A d d P a y m e n t I n c o m e   t o   p o w e r _ u s e r  
 - - g r a n t   e x e c u t e   o n   u p _ U p d a t e P a y m e n t   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ S e t u p U s e r R o l e s   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ R e g i s t e r C h a n g e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ S e l e c t P a g e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ G e t R e c o r d C o u n t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ G e t N e w M e s s a g e s   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ A d d T o G l o b a l H i s t o r y   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ G e t C u r D a t e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ S e t N e w C o u r s e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ G e t L a s t C o u r s e   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   u p _ N e w S h i p m e n t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ N e w S h i p m e n t D o c   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t D o c   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   u p _ H i s t o r y A d d   t o   p o w e r _ u s e r  
  
 g r a n t   e x e c u t e   o n   d b o . S p l i t C o u n t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   d b o . S p l i t C o s t   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   d b o . G e t P a y S t a t e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   d b o . G e t P r o c e s s E x e c S t a t e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   d b o . G e t S h i p m e n t S t a t e   t o   p o w e r _ u s e r  
 g r a n t   e x e c u t e   o n   d b o . G e t I n k N a m e s   t o   p o w e r _ u s e r  
  
 d e c l a r e   @ E d i t U s e r s   b i t ,   @ E d i t D i c s   b i t ,   @ U S D   b i t ,   @ E d i t P r o c e s s e s   b i t ,   @ E d i t M o d u l e s   b i t ,     @ U p l o a d   b i t ,  
     @ E d i t C u s t o m R e p o r t s   b i t ,   @ D e l e t e C u s t o m R e p o r t s   b i t ,   @ V i e w P a y m e n t s   b i t ,   @ E d i t P a y m e n t s   b i t ,   @ A d d C u s t o m e r   b i t ,  
     @ V i e w I n v o i c e s   b i t ,   @ A d d I n v o i c e s   b i t ,   @ D e l e t e I n v o i c e s   b i t ,   @ V i e w S h i p m e n t   b i t ,   @ A d d S h i p m e n t   b i t ,   @ D e l e t e S h i p m e n t   b i t ,  
     @ P e r m i t S h i p m e n t A p p r o v e m e n t   b i t ,   @ P e r m i t O r d e r M a t e r i a l s A p p r o v e m e n t   b i t  
  
 d e c l a r e   U s e r C u r s o r   c u r s o r   l o c a l   f o r    
     s e l e c t   L o g i n ,   E d i t U s e r s ,   E d i t D i c s ,   E d i t P r o c e s s e s ,   E d i t M o d u l e s ,   U p l o a d F i l e s ,   S e t C o u r s e ,    
         E d i t C u s t o m R e p o r t s ,   D e l e t e C u s t o m R e p o r t s ,   V i e w P a y m e n t s ,   E d i t P a y m e n t s ,   A d d C u s t o m e r ,    
         V i e w I n v o i c e s ,   A d d I n v o i c e s ,   D e l e t e I n v o i c e s ,   S h i p m e n t A p p r o v e m e n t ,   O r d e r M a t e r i a l s A p p r o v e m e n t ,  
         V i e w S h i p m e n t ,   A d d S h i p m e n t ,   D e l e t e S h i p m e n t  
     f r o m   A c c e s s U s e r   a u   i n n e r   j o i n   s y s u s e r s   s u   o n   a u . L o g i n   =   s u . n a m e  
     w h e r e   I s R o l e   =   0    
  
 o p e n   U s e r C u r s o r  
  
 f e t c h   n e x t   f r o m   U s e r C u r s o r   i n t o   @ S r v N a m e ,   @ E d i t U s e r s ,   @ E d i t D i c s ,   @ E d i t P r o c e s s e s ,   @ E d i t M o d u l e s ,   @ U p l o a d ,   @ U S D ,  
     @ E d i t C u s t o m R e p o r t s ,   @ D e l e t e C u s t o m R e p o r t s ,   @ V i e w P a y m e n t s ,   @ E d i t P a y m e n t s ,   @ A d d C u s t o m e r ,    
     @ V i e w I n v o i c e s ,   @ A d d I n v o i c e s ,   @ D e l e t e I n v o i c e s ,   @ P e r m i t S h i p m e n t A p p r o v e m e n t ,   @ P e r m i t O r d e r M a t e r i a l s A p p r o v e m e n t ,  
     @ V i e w S h i p m e n t ,   @ A d d S h i p m e n t ,   @ D e l e t e S h i p m e n t  
  
 s e t   @ O K   =   0  
  
 W H I L E   @ @ F E T C H _ S T A T U S   =   0   a n d   @ O K   < >   - 3  
 B E G I N  
     / * i f   @ U s e r L e v e l   =   0    
         s e t   @ n s   =   N ' e x e c   s p _ d r o p r o l e m e m b e r   ' ' j u s t _ u s e r ' ' ,   ' ' '   +   @ S r v N a m e   +   ' ' ' '  
     e l s e  
         s e t   @ n s   =   N ' e x e c   s p _ d r o p r o l e m e m b e r   ' ' p o w e r _ u s e r ' ' ,   ' ' '   +   @ S r v N a m e   +   ' ' ' '  
     e x e c   s p _ e x e c u t e s q l   @ n s * /  
     s e t   @ n s   =   N ' e x e c   s p _ a d d r o l e m e m b e r   ' ' p o w e r _ u s e r ' ' ,   ' ' '   +   @ S r v N a m e   +   ' ' ' '  
     p r i n t   @ n s  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     - -   >B<5=O5<  2A5  ?@54K4CI85  =07=0G5=8O  4;O  :>=:@5B=>3>  ?>;L7>20B5;O 
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   A c c e s s U s e r   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   A c c e s s K i n d   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   A c c e s s K i n d P r o c e s s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ C o p y A c c e s s U s e r   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ E d i t U s e r s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   A c c e s s U s e r   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   A c c e s s K i n d   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   A c c e s s K i n d P r o c e s s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ C o p y A c c e s s U s e r   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   K i n d O r d e r   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   K i n d P r o c e s s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   S e r v i c e s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   O r d e r S c r i p t s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   O r d e r P a r a m s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   S r v F i e l d s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   S r v G r i d C o l u m n s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   S r v G r o u p s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   S r v P a g e s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ N e w S e r v i c e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ D e l e t e S e r v i c e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ N e w S r v G r o u p   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ D e l S r v G r o u p   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ E d i t P r o c e s s e s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   K i n d O r d e r   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   K i n d P r o c e s s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S e r v i c e s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   O r d e r S c r i p t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   O r d e r P a r a m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v F i e l d s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v G r i d C o l u m n s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v G r o u p s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S r v P a g e s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w S e r v i c e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e S e r v i c e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w S r v G r o u p   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l S r v G r o u p   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   D i c E l e m e n t s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   D i c F o l d e r s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   D i c F i e l d s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ N e w T a b l e D i c t i o n a r y   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ D e l e t e D i c t i o n a r y   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ E d i t D i c s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c E l e m e n t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c F o l d e r s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i c F i e l d s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w T a b l e D i c t i o n a r y   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e D i c t i o n a r y   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   S c r i p t e d F o r m s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   G l o b a l S c r i p t s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   D i s p l a y I n f o   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   E n t e r p r i s e S e t t i n g s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ E d i t M o d u l e s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   S c r i p t e d F o r m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   G l o b a l S c r i p t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   D i s p l a y I n f o   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   E n t e r p r i s e S e t t i n g s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   C u s t o m R e p o r t s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   C u s t o m R e p o r t C o l u m n s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ E d i t C u s t o m R e p o r t s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t   o n   C u s t o m R e p o r t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   d e l e t e ,   u p d a t e ,   i n s e r t   o n   C u s t o m R e p o r t C o l u m n s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
     / * e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   u p d a t e ,   i n s e r t   o n   C u s t o m R e p o r t s   t o   '   +   @ S r v N a m e  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   d e l e t e ,   u p d a t e ,   i n s e r t   o n   C u s t o m R e p o r t C o l u m n s   t o   '   +   @ S r v N a m e  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d * /  
  
     i f   @ D e l e t e C u s t o m R e p o r t s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   d e l e t e   o n   C u s t o m R e p o r t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
     / * e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   d e l e t e   o n   C u s t o m R e p o r t s   t o   '   +   @ S r v N a m e  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d * /  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   C u s t o m e r I n c o m e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   P a y m e n t s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ N e w C u s t o m e r I n c o m e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ D e l e t e C u s t o m e r I n c o m e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ A d d P a y m e n t   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ A d d P a y m e n t I n c o m e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     - - s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ U p d a t e P a y m e n t   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     - - e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ V i e w P a y m e n t s   =   0    
     b e g i n  
         s e t   @ n s   =   N ' d e n y   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   s e l e c t ,   u p d a t e ,   i n s e r t ,   d e l e t e   o n   P a y m e n t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ A d d P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ A d d P a y m e n t I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         - - s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ U p d a t e P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         - - e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   P a y m e n t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
  
         i f   @ E d i t P a y m e n t s   =   0    
         b e g i n  
             s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t   o n   C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   P a y m e n t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ A d d P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ A d d P a y m e n t I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             - - s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ U p d a t e P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             - - e x e c   s p _ e x e c u t e s q l   @ n s  
         e n d  
         e l s e  
         b e g i n  
             s e t   @ n s   =   N ' g r a n t   u p d a t e ,   i n s e r t   o n   C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             - -   T O D O :   0  =04>  ;8  745AL  u p d a t e   -   i n s e r t ?  
             s e t   @ n s   =   N ' g r a n t   u p d a t e ,   i n s e r t ,   d e l e t e   o n   P a y m e n t s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ N e w C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ D e l e t e C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ A d d P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ A d d P a y m e n t I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             e x e c   s p _ e x e c u t e s q l   @ n s  
             - - s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ U p d a t e P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
             - - e x e c   s p _ e x e c u t e s q l   @ n s  
         e n d  
     e n d  
  
 / *     i f   @ E d i t P a y m e n t s   =   0   o r   @ V i e w P a y m e n t s   =   0    
     b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e C u s t o m e r I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ A d d P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ A d d P a y m e n t I n c o m e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ U p d a t e P a y m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
     * /  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ S e t N e w C o u r s e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ U S D   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ S e t N e w C o u r s e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   P o l y C a l c V e r s i o n   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ U p l o a d   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   u p d a t e ,   i n s e r t ,   d e l e t e   o n   P o l y C a l c V e r s i o n   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   C u s t o m e r   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   P e r s o n s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ N e w C o n t r a g e n t   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ A d d C u s t o m e r   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   i n s e r t   o n   C u s t o m e r   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   i n s e r t   o n   P e r s o n s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w C o n t r a g e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   i n s e r t   o n   C u s t o m e r   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   i n s e r t   o n   P e r s o n s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ N e w C o n t r a g e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ N e w I n v o i c e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ D e l e t e I n v o i c e   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   I n v o i c e s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   I n v o i c e I t e m s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ V i e w I n v o i c e s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   s e l e c t   o n   I n v o i c e s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   s e l e c t   o n   I n v o i c e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   I n v o i c e s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   I n v o i c e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     i f   @ A d d I n v o i c e s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w I n v o i c e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ N e w I n v o i c e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   u p d a t e   o n   I n v o i c e s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   i n s e r t ,   u p d a t e ,   d e l e t e   o n   I n v o i c e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     i f   @ D e l e t e I n v o i c e s   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e I n v o i c e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ D e l e t e I n v o i c e   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   d e l e t e   o n   I n v o i c e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ N e w S h i p m e n t   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ N e w S h i p m e n t D o c   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t D o c   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   s e l e c t ,   u p d a t e   o n   S h i p m e n t   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   s e l e c t ,   u p d a t e   o n   S h i p m e n t D o c   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ N e w S a l e D o c   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ D e l e t e S a l e D o c   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ N e w S a l e I t e m   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   e x e c u t e   o n   u p _ D e l e t e S a l e I t e m   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   s e l e c t ,   u p d a t e   o n   S a l e D o c s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
     s e t   @ n s   =   N ' r e v o k e   s e l e c t ,   u p d a t e   o n   S a l e I t e m s   f r o m   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ V i e w S h i p m e n t   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   s e l e c t   o n   S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   s e l e c t   o n   S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   s e l e c t   o n   S a l e D o c s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   s e l e c t   o n   S a l e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   S a l e D o c s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   s e l e c t   o n   S a l e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     i f   @ A d d S h i p m e n t   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e   o n   S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e   o n   S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w S a l e D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ N e w S a l e I t e m   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e   o n   S a l e D o c s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   u p d a t e   o n   S a l e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ N e w S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ N e w S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   u p d a t e   o n   S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   u p d a t e   o n   S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ N e w S a l e D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ N e w S a l e I t e m   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   u p d a t e   o n   S a l e D o c s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   u p d a t e   o n   S a l e I t e m s   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     i f   @ D e l e t e S h i p m e n t   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e S a l e D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ D e l e t e S a l e I t e m   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ D e l e t e S h i p m e n t D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ D e l e t e S a l e D o c   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ D e l e t e S a l e I t e m   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     - -    07@5H5=85  =0  >B3@C7:C 
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ U p d a t e O r d e r S h i p m e n t A p p r o v e d   t o   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ P e r m i t S h i p m e n t A p p r o v e m e n t   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ U p d a t e O r d e r S h i p m e n t A p p r o v e d   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ U p d a t e O r d e r S h i p m e n t A p p r o v e d   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     - -    07@5H5=85  =0  70:C?:C  <0B5@80;>2 
  
     s e t   @ n s   =   N ' r e v o k e   a l l   p r i v i l e g e s   o n   u p _ U p d a t e O r d e r M a t e r i a l s A p p r o v e d   t o   [ '   +   @ S r v N a m e   +   ' ] '  
     e x e c   s p _ e x e c u t e s q l   @ n s  
  
     i f   @ P e r m i t O r d e r M a t e r i a l s A p p r o v e m e n t   =   0   b e g i n  
         s e t   @ n s   =   N ' d e n y   e x e c u t e   o n   u p _ U p d a t e O r d e r M a t e r i a l s A p p r o v e d   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d      
     e l s e  
     b e g i n  
         s e t   @ n s   =   N ' g r a n t   e x e c u t e   o n   u p _ U p d a t e O r d e r M a t e r i a l s A p p r o v e d   t o   [ '   +   @ S r v N a m e   +   ' ] '  
         e x e c   s p _ e x e c u t e s q l   @ n s  
     e n d  
  
     f e t c h   n e x t   f r o m   U s e r C u r s o r   i n t o   @ S r v N a m e ,   @ E d i t U s e r s ,   @ E d i t D i c s ,   @ E d i t P r o c e s s e s ,   @ E d i t M o d u l e s ,   @ U p l o a d ,   @ U S D ,  
         @ E d i t C u s t o m R e p o r t s ,   @ D e l e t e C u s t o m R e p o r t s ,   @ V i e w P a y m e n t s ,   @ E d i t P a y m e n t s ,   @ A d d C u s t o m e r ,  
         @ V i e w I n v o i c e s ,   @ A d d I n v o i c e s ,   @ D e l e t e I n v o i c e s ,   @ P e r m i t S h i p m e n t A p p r o v e m e n t ,   @ P e r m i t O r d e r M a t e r i a l s A p p r o v e m e n t ,  
         @ V i e w S h i p m e n t ,   @ A d d S h i p m e n t ,   @ D e l e t e S h i p m e n t  
 E N D  
 c l o s e   U s e r C u r s o r  
 d e a l l o c a t e   U s e r C u r s o r  
  
 - - -   E N D   O F   U P _ S E T U P U S E R R O L E S  
  
 g o  
 e x e c   u p _ S e t u p U s e r R o l e s  
 g o 