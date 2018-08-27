#include "sqlele.hsp"

/**
 * ���ۉ��Ή����s�����W���[��
 */
#module i18n
    /**
     * �f�[�^�x�[�X��������
     */
    #deffunc local Init
        sql_open "language.db"
        defaultLang = ""
    return

    /**
     * �f�t�H���g�̌���ݒ���s��
     * @param lang ����ݒ�
     */
    #deffunc local SetLanguage str lang
        defaultLang = lang
    return

    /**
     * ����ݒ�ƃL�[�Ƀ}�b�`�����|��e�L�X�g��Ԃ�
     * @param lang ����ݒ�
     * @param key �L�[
     */
    #defcfunc local GetTextLong str lang, str key
        sql_q "SELECT value FROM message WHERE lang='" + lang + "' AND key='" + key + "'"
        if stat == 0 :return ""
    return sql_v("value")

    /**
     * �f�t�H���g�̌���ݒ�ƃL�[�Ƀ}�b�`�����|��e�L�X�g��Ԃ�
     * @param key �L�[
     */
    #defcfunc local GetText str key
        if defaultLang == "" :return ""
        sql_q "SELECT value FROM message WHERE lang='" + defaultLang + "' AND key='" + key + "'"
        if stat == 0 :return ""
    return sql_v("value")
#global
