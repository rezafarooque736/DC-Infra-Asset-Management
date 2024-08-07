PGDMP     5    8            	    z            dc_infra_asset_management     14.5 (Ubuntu 14.5-1.pgdg18.04+1)    14.5     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16495    dc_infra_asset_management    DATABASE     n   CREATE DATABASE dc_infra_asset_management WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
 )   DROP DATABASE dc_infra_asset_management;
                postgres    false            �            1259    16588    dc_infra_table    TABLE     I  CREATE TABLE public.dc_infra_table (
    "SNo" integer NOT NULL,
    "row" integer NOT NULL,
    rack integer NOT NULL,
    service_type character varying NOT NULL,
    customer_name character varying NOT NULL,
    customer_project character varying NOT NULL,
    ci_type character varying DEFAULT ' '::character varying,
    asset_tag character varying DEFAULT ' '::character varying,
    oem character varying DEFAULT ' '::character varying,
    model character varying DEFAULT ' '::character varying,
    serial_number character varying DEFAULT ' '::character varying,
    hostname character varying DEFAULT ' '::character varying,
    ip_mgmt character varying DEFAULT ' '::character varying,
    ipmi_ilo character varying DEFAULT ' '::character varying,
    amc_start_date character varying DEFAULT ' '::character varying,
    amc_end_date character varying DEFAULT ' '::character varying,
    remark character varying DEFAULT ' '::character varying,
    created_by character varying DEFAULT ' '::character varying,
    creation_date_time character varying DEFAULT ' '::character varying
);
 "   DROP TABLE public.dc_infra_table;
       public         heap    postgres    false            �            1259    16543    deleted_data    TABLE     �  CREATE TABLE public.deleted_data (
    "SNo" integer NOT NULL,
    "row" integer NOT NULL,
    rack integer NOT NULL,
    service_type character varying NOT NULL,
    customer_name character varying NOT NULL,
    customer_project character varying,
    ci_type character varying,
    asset_tag character varying,
    oem character varying,
    model character varying,
    serial_number character varying,
    hostname character varying,
    ip_mgmt character varying,
    ipmi_ilo character varying,
    amc_start_date character varying,
    amc_end_date character varying,
    old_remark character varying,
    deleted_by character varying NOT NULL,
    date_time character varying NOT NULL,
    deletion_reason character varying NOT NULL
);
     DROP TABLE public.deleted_data;
       public         heap    postgres    false            �            1259    16513    login_history    TABLE     �   CREATE TABLE public.login_history (
    "SNo" integer NOT NULL,
    fullname character varying,
    mobile_number character varying,
    email character varying,
    "Date_Time" character varying
);
 !   DROP TABLE public.login_history;
       public         heap    postgres    false            �            1259    16518    login_history_SNo_seq    SEQUENCE     �   CREATE SEQUENCE public."login_history_SNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."login_history_SNo_seq";
       public          postgres    false    209            �           0    0    login_history_SNo_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."login_history_SNo_seq" OWNED BY public.login_history."SNo";
          public          postgres    false    210            �            1259    16519    register_temp    TABLE     y   CREATE TABLE public.register_temp (
    id integer NOT NULL,
    email character varying,
    token character varying
);
 !   DROP TABLE public.register_temp;
       public         heap    postgres    false            �            1259    16524    register_temp_id_seq    SEQUENCE     �   CREATE SEQUENCE public.register_temp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.register_temp_id_seq;
       public          postgres    false    211            �           0    0    register_temp_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.register_temp_id_seq OWNED BY public.register_temp.id;
          public          postgres    false    212            �            1259    16525    users    TABLE       CREATE TABLE public.users (
    id integer NOT NULL,
    fullname character varying,
    mobile_number character varying,
    email character varying,
    username character varying,
    password character varying,
    token character varying DEFAULT 'none'::character varying
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16531    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    213            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    214            5           2604    16532    login_history SNo    DEFAULT     z   ALTER TABLE ONLY public.login_history ALTER COLUMN "SNo" SET DEFAULT nextval('public."login_history_SNo_seq"'::regclass);
 B   ALTER TABLE public.login_history ALTER COLUMN "SNo" DROP DEFAULT;
       public          postgres    false    210    209            6           2604    16533    register_temp id    DEFAULT     t   ALTER TABLE ONLY public.register_temp ALTER COLUMN id SET DEFAULT nextval('public.register_temp_id_seq'::regclass);
 ?   ALTER TABLE public.register_temp ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211            8           2604    16534    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    213            �          0    16588    dc_infra_table 
   TABLE DATA           �   COPY public.dc_infra_table ("SNo", "row", rack, service_type, customer_name, customer_project, ci_type, asset_tag, oem, model, serial_number, hostname, ip_mgmt, ipmi_ilo, amc_start_date, amc_end_date, remark, created_by, creation_date_time) FROM stdin;
    public          postgres    false    216   `)       �          0    16543    deleted_data 
   TABLE DATA             COPY public.deleted_data ("SNo", "row", rack, service_type, customer_name, customer_project, ci_type, asset_tag, oem, model, serial_number, hostname, ip_mgmt, ipmi_ilo, amc_start_date, amc_end_date, old_remark, deleted_by, date_time, deletion_reason) FROM stdin;
    public          postgres    false    215   o^       �          0    16513    login_history 
   TABLE DATA           [   COPY public.login_history ("SNo", fullname, mobile_number, email, "Date_Time") FROM stdin;
    public          postgres    false    209   �^       �          0    16519    register_temp 
   TABLE DATA           9   COPY public.register_temp (id, email, token) FROM stdin;
    public          postgres    false    211   �^       �          0    16525    users 
   TABLE DATA           ^   COPY public.users (id, fullname, mobile_number, email, username, password, token) FROM stdin;
    public          postgres    false    213   �^       �           0    0    login_history_SNo_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."login_history_SNo_seq"', 36, true);
          public          postgres    false    210            �           0    0    register_temp_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.register_temp_id_seq', 1, true);
          public          postgres    false    212            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 1, true);
          public          postgres    false    214            O           2606    16607 #   dc_infra_table dc_infra_table_pkey1 
   CONSTRAINT     d   ALTER TABLE ONLY public.dc_infra_table
    ADD CONSTRAINT dc_infra_table_pkey1 PRIMARY KEY ("SNo");
 M   ALTER TABLE ONLY public.dc_infra_table DROP CONSTRAINT dc_infra_table_pkey1;
       public            postgres    false    216            M           2606    16549     deleted_data delete_details_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.deleted_data
    ADD CONSTRAINT delete_details_pkey PRIMARY KEY ("SNo");
 J   ALTER TABLE ONLY public.deleted_data DROP CONSTRAINT delete_details_pkey;
       public            postgres    false    215            G           2606    16538     login_history login_history_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY ("SNo");
 J   ALTER TABLE ONLY public.login_history DROP CONSTRAINT login_history_pkey;
       public            postgres    false    209            I           2606    16540     register_temp register_temp_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.register_temp
    ADD CONSTRAINT register_temp_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.register_temp DROP CONSTRAINT register_temp_pkey;
       public            postgres    false    211            K           2606    16542    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    213            �      x��}kw�J��g�_��Ηd&r���G!�67#��O��"�$�Ɛ��̚�[��n%;��&0V=]]]]U]]e�@�h�\�+���/���*��w�u��-���p���/��[���r7��<��fM�9!x;1�����'3{:}ۛ�g��f����0�r~:�U
��M�<x	<��t�~]-��r�6��z�ݬ����r�0_�^��y�}�a.s�ux�r]<"=$��Ym ƻq�3������Ѥ12�e74'H��~+����� �?l���h�7�Qg����|����$?O��m1Gr�.�����~�m�a��P ���V���M����1�_.�{����}��[m�&�7�������ɮ����׾-�O�b��-��������f��9_HP��Y=�a�_K�{��u4R�����vo�~��aÔ��/6��_w��)1�T7x7�ߟH�)�4�����j&�l�%*_�b��2;Cs�  ����ѤYj1"t	ܑ`���r� m(@��ֆ�����[��hIH����Q��4�$��fk��A
bc��J!�L��+�V����o��d��F�RH���H
.�T\G6�́�����������c���g+��o���p5��l�2ԛ7�ױ!�W��b����qa&�cȴ-�&$5��lH�m�rt��+D��C�}�lA�01P/�����ñ��c3>��\���VBT7q�6	q6=��T�=F �k�>���n���4R-��AW��W�J�x��$r�,�:����e��@�N!���A�@�E��;E�A␈�+&Zw?Q}l잿.�O��vc�|]����0:���ί����>��
�E������D�m�H�0f��N}������v�\]}�|�Z��ap��fWp�/����j�B\oLw��e��)Ț�� �J;N�d5[���v����X������\��EY鬒��|�n/?Y�0��r?_)⢓W!(�@�b��;X
����g���V���Ҏ!�4�`���9���l�EӮ��{M� �~c��f�G��6�+��	�9�88���l�R��#k
�㻰�ī֘A��q��E$7^̿��ͳX6;�8��P���gQ#�Q�gQ�RDX�;��r���07���b��1_�6_>}m��Hkh�Xg�C���]-YA�]w�b�n�r��K�F����6R7��IO�Bs3�J��mtP��j��Z'VHy�Ha�+f�)�v�@Q>PvP��ER�C����	���V߾���������-�h?�|��v�U.����Ů������s�cș���9;_hR
���G�pќ��x�ش,R%� �E@��S�S6+�B��r�h���Y���A�)�P��E]���Cp_2��/�7�.�f����������C����/i׳0!�F�6��+׾nǯ����i43��:Lh� �����Ȥ��N�폼�W���:���BE���b1{4p�x�����1%��M+
�0�m]����3^I�^̾\=gh�^訅0�}'<}j��UCh[�@d7�ݞ�o�1�e]b���9(�X��� �}��<�e��K��|��D/с�#N��n\����2�W��?�H��
"��b!��T�
ˊ/WG����������~��Þ�h~�h�1�b4�`�n�u֏B1��w��wj����m��P��g7�����9���h�o=\G�ų�����f����[^A��x����.֋�jO�\�XT
��e�[�ޯ�B����~�j��&N�N\�ƢW��;22�A�k���D��Ѓ��Y��D� �@o��n�4����0=~^
5��<��t��h��1p�X�0������B�Rci�>n��@�7��b�?�7|%0�B���V�
��TwYN�ݼ�p"��}���;�22��K9���@��A�Wr8%���))�5��N�����w.�"F�LF��Z�7g�S#P�D\�֌@@J�c����#wŗ߭�p�����yױ�����N����Ld�mt��d`�#&Ե߅��a���z������+#���7_w���k�Ư#�=�{+}`�h	j�Ć6�N��B�������1�Μƻ�A�����d�����~�����b��S �7��|���M �����ûr8��܈��F��==1b��a�.�F_R��hH�`I�s>~��%m������y���y��F�H���KbT#F+%F^#�E��i6�=���M���x0r[��ܜ�����Y�	�@��(��[D���3�������):E(�͎�0�������m$~��mv�{��Φj�\��F�+K��32��2�\�	Vaj�A[�x�o˝����Ti?��Kw�c�Y/��OĻ���p��ʆ�����p�c���p\��+���N�#��P:�D�%��孞w�`�t�������"ni�chv����90D�wCa��d;��=ܒ��fǪE
K����P�RY�Osw �F^W1_x9/N�������]t�!�������)�)�G����i�*1��2�N�;9mx��
=�/�*���u ����BkgC�s�����
.K�+�$��:��Ep�Q �NwY>\�%�"Q�w���9�;&���xZ텡EmF	2�/�'��&�ިG�_�7�#M�
�E�"���I�f����nobʀiM�o-�f} `7������XnhŎ�<t^Y�1T�P�!ؐ�A�]|5}��!�
e����Ki�#
��Bėk=��叜pv%SK��'�7f�x�CP'��
�wMux(tu�3B����m<�_���H������t��S��������1}pP�p8T7҇��á�p�@r��K�SZ�%�������L�t<�Z�xP�x��xpl<�p.]<������� }8�.o.�p8$}8=}8��'o.Tm������߲0 ��z�#�) 1;�~)C�ᦩ{�BH���O���t�����.f{��]>`�UH3�=nQ]��}��t'��-헭y�<)\ͧ���6H�'�'�?���<�����a����%��/M��)��4�T�!H������zZ�M��6�E<�� 0b2��Ԓ�wO���ȶd3L�c:d0l�t7����Q�f���~�$>:��K���\+� `k��+^_���z,Ryi�ߺ Q���c���/M!~ F}&L� �?�R�9�(Y)�2}I����n�Ә�$��1����xez�o�6e��r�i.<s�K���
S�yM�Vo���*�j.>F�K�z����2r?���.{�k�rY�X�@��Đ�@QP�!��1�bƂ�X��c2T�H7r�z��oW��I����(ӄ�1�$D��gfIwj=#�d�J�X|_��`��ׅ��	��팼A?�7:L<�tk�3�Y��P�bw�)��Zʰ�5=��샷�Y$�� Z��^z���_-���;s�}c�7��*l�01z3r{���v��&�	n���>h���_�47�[s�髩N%?m���WM�$�A��X<3�Ӑ����Wy�/-��R�d֋����\��2a�T�t.�'�����	��'��:?�v?y�|�?��'tN���t~
�ZU	3T%��tU�@���@S�8UUByY��Әujc�̸l����b���p	
Otf�u8�ē`p�f+s��3,�\����S/[v�����_�ɢ����H:v0!�#���������ʣ��r?�Yh��@Ο9*x�Jݦ6M�ׂ��7F���u����arJ�����
(̡���|e������{�?�;���E/ce�2�5V�8+m��go;�+�e�trY�8�2~�.s3��<[Y�v�D���\V�ё�0�J���?\��/c%�e�h���f�}��>���O
�]�`����2%0LU�!�e
�(��wn,�����՜�:@�8 ߌð�b����J/TfIlT��%����B��o�dt2��`:v�A��)����    ί�����Nϝ4��'
�����9}�3A�	`�D�=q� %�J��J��A�����W��\^I�,����p5�</a�G�j�B��H�y��
I`mW��$>2���C�%=����Xl��bx!O@]��d��l��4���{��_gO�� h�x�5;��������F�I�L:Νt̏���'铞��)��$<���|�Xo����O� 8����|�D賈�+ �n���Z���6tA:x�L������~���8h����-�B��*�`:l�5���q�bgC��Y�=IUi��`��|�H��'0O`�Q��Ms���6xn�a�w��ז��Y����A
���n��+D�/�`x���?���2dH����WSb�؉-�sx8`+�N+-�a�(��0N���\�<�R�,V`�T����I�q�z�� �<��Ө�d»��+D��nu�R�*:��_ҽkǸ~��#�1�b�7Z5���p�<3S���#s�e�3�a�ȍ��B�9�$�qAs��n.�;9G�/��r�0?>����旅p3�Ɍ��Z�1���&��a�&� aYP�n�&����[݆۴d�AL �,���W"ВD�\��?I����c��n��_�W1���ä�������th�Ҭ?nv��,PLQ�8��b���8>��X���SڍIt�`r�Õ-��A� �B���h��Tź�2�Fn��o��~�Wxp�x�|<,��Uq�p��T�2E�dA(!S��Q�<�O���S/y*�p�ЉjH��d��e�@���.�2��Ӫ��X�zp�Ԥ��������1�ovA:�g1�AL�U��s���8���e1tRK=��B���7w�f!�Z*�r$�e���m�yݤ� 3�@7c* x�����D3#����u�hx)��e�fz�j���(��y���B�4���e��۪I6�Ym8��'�!q?<%&/�I����ir t�'�ptЖE��˸��'�������D��i�Q�K�k�$SZ���!����7��gcAY�2(k4���dbg���l�L��m�������_}�kl��)�s	gq|oN�Y.s�W��lj�٣J�v��߬M*+y��ˏ�O F�´0�+�püX�M��2�V�#� ���75��r������j���F���C�XN���K�A��ڻ��V.֩�P
�Y��gv�ck_^�7�ղȫ�D8�҅
֨Ͷ����qf���p�u`~kB`�j���(>�w<�V�;�]�掬�oAĈ,o���ڻ���>M��$*�*��t����	���>x�w3ƙ�Ψq�
�'dd��B�q ���LL�@<�H�J��&~��#`�N��^Tr0��0�����O��Iل����]a´B�^�E��;���2	=��傕���� �����+�Ѡ�q��ֻ2v��@����F�{�U��Dh6��Ьu��½?n�LOξ�ڮ�w��e�����K���Z���Y��aV9�οBWm�-�f�TE.�U��[e`�B�����6v|4�~����vm�߮a	b.� �>!�Ѹ�&|FņN�˕kW���
�&L�%��!�0���Ma¼Z���N��n���ia�N��{E	;YjL����N�[7����f�.x�BVw(�.?���v�8��a��xoj�+�N�f��A�-ʘ��ph���,��cE�ܪC�i��*�g5ձUQ��E|���
�������;�H�ߐŜz���v.�`#�y�~��U�ȹ��ܹ�}�P�o�N^��M�]�Î;!¾1�6����;[n��n�~�M!��nF9�,��E52:�e!@Yܞm�?�� �3��:�2���v���j���xph���{����:.(�Q���s2��d}v����-L���GL�X�=2$/CgH�		��h6�0�Ȩ�Bm��[��^���׀d�:%K(���D�J�� �)��^�ifCפP����=!��o�3�~^/�
ݘb"��?�ݧ�mf��d�1���.��G�>#�p���ӫ�g�8��u�P�����ct|���ϖ��Qx_"N�m�W�Z�E2:)�Tl&�Rp��@��:����x:�Y>@��?�MCSO�frhF\�-@B�"c_^�4�=6p
>�KZ؞vT���R7�d<��p�of˫����:���^�\ �,��]��N�R��S��2�4�w~�c���71��qYF�2�̥�uG�[����A�	<�"�`�]� )N �"@@�Q�Lyb�&p[�@�W���C�UG-�i�yuG���$�XNEp����,����D�a�����|E^gn��MD��I���
8��R�v���_~��7�\��fw���"�؎jV�i#L3C���[ߍ[��lQ�ʑ�����{��WZy �/,��^���A9|������.�e31��%ܯ_���#.���P�<�������;[����o�z]1��V&9�eq��V8�OP�B���9�w�����뿅���4Sdݸ��`ϕn���n�BV���Y�a?�8ZN`E�`*,y!+
X0	K�E
ª���Co]��ӉB>��&�}�6��2NXEi�y}N��nO�L����ָ���aǳz8�ˎ��=���\�c������E��W�ۂ�uA�T��'b��P���m � fT��N�����O.Z9�0ˋOg�� ���N�h1�/eD��62tm�r+��~�kN��[	���so���o�R�s����կÄ�f�ذ\5f_�g��)M��k��d���*h*w��Bet�����ul.��Z�s���@�@�ۆ��$���q�����}�G�R�!��R�4��j�O�M�?���T�MYl�J3+��� j�%HÊH�t�b�I�4���j		>L/�]�}0"�P��2/ �w�
���MTɵsݎ�]R�	&:~Z��'��ca�{y�X��ca�Bs[~gG��>r���X��!c�v�Ѫ�)ͮ�sQ�U��zWڽ��v�:�н��w������s�W�
ߕ����A��A@;>^`��A���@�A��A�� X�A���ӛ�9�A��A�k
ʆL���U��8�⤣���c#����ذ���*�(��B�G:U~�(v���̈s򵬄�X�'ܒ�4v��\#�mi/;��k	�H)����PrL�a��{��v2����6�j��?�}\-�f����07��7f�q��.TL��s|t|��H�;��Vx��9�������u 7Yysu�����n�~�u��Iޖ_��y%׀����<S"��!h���u:y��S a�\�^�NT�HVޞs��	��МBN�-������v����f�����ctS�$"�ܒ9@������ޭ������=��v�!�dHX��0������\o�����l�C����G��7f}22���,;� �j!�DHr���?�URPኰ��s򸘭?������§@-`fW��FIU#��3{|��R��g���J�/5M9�������j0�_��$�q���4a ������./>��|Mm[���t)^����$<t���M�/�+½T7ܚ�A(�A�鱍��3��mz�Q:�Q�xm`z�PRӟ\&�����&l��b߹ݺ�\?{V5�0�"�*H�i��?��OJ�:Fo�[��p�������a�
��l'���ki�:N��,�W�F	���]� .�.v;�I\A�P�R?�;���G�t?�$���au♐HRz0=��"�[���
͏�ؤ�T���Q��V^R�\Jހc��op<xColT� 2�7�0N��x���ظ�A�o ="=x�����AL�����ȽW9����m5"�4=_�9g����RС�OS6�$�᤼����ZM�Y�b�TV�T.������r,�p��9�P��-vk�]���=�߲��Z#G(�rC'j	m�*,	�rUΑ��v.Ny�$e\~�t��Q��[yhr���u3�x&�H�3��]?��<�
{VT%2h*�&h��B�n�M��RK�q͔��[��֔�    ak1�F���G&'�P���A�� �A��A��z�?�)3����"�x�Y���͎2�t�Q�1D�w��U"�Ԯ��[ⷄ5n��)���5�7��蕰���+I�a���	��	��)ݯ=��BS�:�ϩ���1ke{��;6��Vbb0��X^M������a�?_p
�b��Ո^/ۉ1Gl���م�ߨ%V��
em5{\$�2�S��_�ÖZQ^}��~9�r �Dh�"�"~�J##h^��6��n��Qz�6!'�����t�o�w'¦z��2&'V3��0�Wfl���=9]l)6�LaD�`d/riu��?�ʗX�<Ag���b�Uf��A��F7\d��B�m%�Ny�����d����i'�'���j;cU;u�qPx����J�TH�N�]��|BQ:�pr&3�͖#����O�r��\���G<���U{�]��ܫ�N�U�H�P\:��<&����j�1j3�Hh�/�'��'�LGEX���iZ��o_��Z<I�4���d؏J��d�o����o�#��!�.�KG��H�^K��mL��*�)��@Y�51�S�R�6H���(��d�Z�0f#&��ĩ0a�0Q���$3-���G�Q6C�4����r��A�C+�a�7���g��D���L"��T��Cc��$Z�T�"���5=A$>8A����'��e���oW%��ְ�;ޓ��,�Kޤ
�R�\�S��i�;���S�Ѐ)�����w�t�ޯ����~��m���>�����I�[����O�'��3�Gן�Or?������O�'=�grö?���2~�_?�s����IN�����%�2~��*��y;���SO�Ԧ�����yN��~�wa84�n��Dq~�~&7����i_������'���������hUB��(?ӻZ����}���O����I�e�L��wX�=��q��'��|�ė�3��¡�;�� �Op�O���\�����)OK4~"焟��L��WʈSz�<�|����^ygM�G�d�>��������':?�qt7@|܀����� |G�g<n�N����P�2~��e}O�g<n�N����P�2~��e}[�g<n�N����0p?���vC�g<n�N�������2����:?�~:���3ֻ��������JR[q
Į{��Fm��^C�/Ǒ�8����o7�Z�C�谊��:��^)�u�KD�M�W���M�2������0��U�@T��%�ꢰ9��j�x<�8|�~���ؗ���OCɟD���ؽ��55)��<G��w�}4���$��E�b�	�M��O�C�1���~�ˊ�U�yp���|+�,�݈aE#&/G�#Z�F[��A��1�G'dG���w_eAV��sV
BB�Ǩ�#g��W$�Kx��J���}N���6ͺ�����BL�sλWQ�M&��!�nt�7:���2��(r���ZI��ez��`4������LHe9�f�sC��-�'G�+�^u9����)�k�
�,��-��Dwi�\؃b�`�Y	4)�#j���/@�+��>F�v�h$wZU��F��g4"���.#X��i�Pq�����T���#8��63��:t-[�u�~E s�
$�Z�T�ɶp�;�X�B�Y���Y����	�j	gԖ8!lWK�p�RJ���B����G�&%�F����]�ir�.檧����|�ʄ|n�ʋR�0�;��,ƚ����н�#_I�Y�I���Kۥ�BP��Z@yB�]��<N�Ņ;੥R�EH�'uP�C4���9���:m��M���x���-��2c��2�n����E� &5p��rUzJ��LqU�t$[��f̎@��k�pZ�^ �@3�6)Z�8yG�U٫f�0e^~�mζOV�;F,�� � �X�!�T (�f�鵅�A'�et�S�efԨ���%�v}k�s}��}g�$4�`Ȟ�^��WP
a�.�(��v|��[��09��Z\��t�� y�%s0��q}�ZƲlN\t�]F5��v�9�e��h�1{~�$����6�n�6rG�%��Sr= <�{S�R��5�M@Y:��G^��q����Y}�ڈg8����کeL5�5�;����M�:I�t�F���dqnC�v(j��l�W��\3��y�pb��w�9'g=<�z�36+�1a�����Q�wo�K�Od��0�O2|���&*M���*��Uս��h\��lk<�OM�3����szJ��w���t\��2˦�q���e:��x����!,Eۤ�PU��� Tz6�A@�Ta�U�B+Ik9����j�,���ln�i'e?������Huƹ� 3�V�ӿQ-�=B�����`��Bػ�E).pe���c�, ��a Z�eKpF�He0iL��},��<&�&K��x��`�&]�j��?˧��Y*V*��
�k0m*���9Y0�-M��Ie���@y:L�)��(I�y�Q�&���[T��X2���	���U���5���:*�Ѥf��l�&>ۈ���$� �'j�>�=��{�
����z�]�~��ն`�|'���o�Ō�U�蔂bgW����#��0������L}K�y!-1A�?�|*��|��eQ�o�c1y�Cf�a��u�r]�Ŀ*o!��T�%e#U�
���6�*տH��>�<���rrk
t�@�DndԾ������~�5셎*���%[��/CVsR��X��)�*Bp����M�v��^��]BU���V�xt4 
y�2,��i�@�)P�}GJ�H�8P��U�~�ѮÉ�8�8N���W��I�ي�DG�<�dഥ*(Rx�N%Hh-���$4��d<"(�(N`h\@m(�eY@I�@I�8G�Ł�,��Z�4a��K�i@a(�ZK����	�.�����$cWHc��k�W��G+�P#i�w!�+]�H�$�q9)LԌ9��8�uv
�8 �m���YSY�)�i�I3��͸���L%D����f�EF9�=$ܪM3�*Ud�L�a0�6�C�. g�����]�	] �sϊ>~0n�h]ȗv�!�����0!�uX2/�nYs�Z����n�yLҰF�!��푱[.����x�,�)Uz
����Z�������d�O�����lcPi6TXj��[���_�wI�k���mf{�Z��9t�l���/���j.>��b�0�}���\O7���?�c��x0 %��<���A�^�t��v�����i�Bz�UbF(4�E��� 4���A�R�ń���_�fn���i3�]΄'��|Ξ�j;��ƶ��la��[pҙ�1��1Wj��A3�!����D����L$�fr�,��%���)m��P��a�?��g��R�)Ė��Ǡ�Pb�AbqL���}�2�4\�.�ddq(Y�y|�;�՘,m4"h������#�OI�1A�(
�u���}D]�QPu;U�	�ժak�X�R������'\]+������#��՘�y��24�,�DL_����,�/�0 �����ԕ���8E������O��?�Z�N�r�=�=�<zCD��@B1Όl���V�e��	��
��3b^x08�<��+c��m "X�ܩ�5T5�Ơ�-�xn���,P���k]2�>�ǩ$vU���A [��kO�D�	�O��A�""y���%)�ӹ噊Ȯ��=ZD�N%� ��<��3�,q�R(���ܢt����Nm�I �=�@��јB��
k�I:zR)z���a���葎������g��4�>}3B�f$�ʥ�g���9�Cb�i:z�r���D_��@�ңyJ�cIJ�('K�A�<����^Gg8`����p�..T�>���&1E��&��&q�� X%�XRA���y:﹆�NG�*Esг�t�jV��m��W�e�wb�t�h�}D*E�eH�㘚�jh�S=Y
�hRiR���|=��$����z�j�x�e�P��G1�u��<CR�J�g3bC��uL:z��O���J��3�Z} �  �~��~O�pO0�}�1#IC�nHB͐��F<���ϱj��tCj�$N7�1�}�e V-i�Ч�P3$q���9�V�\��e#L���̢.^FB�.�3֜}�.��#�C����+hc���D��V|B���
[$'�[��rk0���t[Q[�Š�Y+e��Z6�s��)�Ι��K2G�j�-��n��>��������5�5������mP��ʤ!��Z���:���
<� |zЈ���|�>�ڸ�* �^s3O�<�����K�+���.C�l���i.xt���.xR��*���G�,<��'?U�i��K�8_;�����>���* �^���m�������"+��r�vz���Ǐ��|�D�\#[�?w#M�^!��m�x��k֑�g��W;l��G1+ ĭ �cL��+ �X�#�cDy��u/#���Ę$��
vB��-�[*0�RqP�s-�>>*>�o� �R�閊�+ �k��^U >�R�����
�T >�R���;�ϷT�n��tKš�/`��#�|K�JJen�U �����-�[*)e�x^����|���uK%�f�oW >�R�c|���uK%����~� �ɵT���>�R������C���܍4	|��r[���|K�JJk	*U��?|�����V?\�q�T��������a��)yЖ
�U ��k�<���a��)���
�_^��S��G��;�~6S�$*�v�s,�����wX�h
���T��3��f󿟿������p�v3~��˗QԭB��&#c�y\��I=���$U�S*��S`�!�̓�v�����%@d!�Wa��Qn�*��p�5��7�A<t��Q�- #�vT�Kem!Xi���z��
}ȄA�G�(�(!w�u_��(\w�Q\�(����P���7�;7ƨ�e�Ѩ�i�����5<N�\O���������l�[3�W�ۃ�i�~.�HҼ���1 �'��@0��l��'O}9T_��W�A�Q�`"�`N�N��.'��fOꍜ�p�\LC�9�i�re1��y�������(� ng'j0\����B������@��֍c\[� _]	>��"0�2��ŤQ6i�42#���6m/�FV��k�����r��Na$\�a[��+P�*1�<����<��C���QS��f%P� ��I���Qџ��X��"��!Y!�����S�_���_�I�RK      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     