-- runframeconf.lua
-- �ܿ� ��������

local run_frame_conf = {};

-- �ܿ�״̬
run_frame_conf.STATE = 
{
    CREATE  = 1,    -- ����
    INIT    = 2,    -- ��ʼ��
    ENTER   = 3,    -- ����
    READY   = 4,    -- ׼��
    RUNNING = 5,    -- �ܲ�������
    FIGHT   = 6,    -- ս��
    FAILED  = 7,    -- ʧ��
    SUCCESS = 8,    -- ʤ��
    TRAP    = 9,    -- ������   
    PAUSE   = 10,   -- ��ͣ
    TRANSMIT = 11,  -- ����
    MOVIE = 12,     -- ����
    NONE    = 13,   -- ��״̬(�����κ�����)
}

run_frame_conf.UI_ZORDER = 41;
-- �����ͼʱ�ƶ��ľ���
run_frame_conf.ENTER_DIS = 360;
run_frame_conf.CENT_Y = 250;
run_frame_conf.TOP_BORDER_HEIGHT = 180;
run_frame_conf.BOTTOM_BORDER_HEIGHT = 80;
-- �˺�����
run_frame_conf.DAMGE_FONT = "fonts/strfont_Damage2.fnt"
-- �����˺�����
run_frame_conf.DAMGE_CRIT_FONT = "fonts/strfont_Damage2.fnt"
-- ��Ǯ����
run_frame_conf.MONEY_FONT = "fonts/number.fnt"
-- �ظ���������
run_frame_conf.ADD_FONT = "fonts/recoverHp.fnt"
-- ���Ǯ����
run_frame_conf.ADD_FONT_FNT = "fonts/strfont_Money.fnt"

return run_frame_conf;