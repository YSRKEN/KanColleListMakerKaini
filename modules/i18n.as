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
    return

    #defcfunc local GetText str lang, str key
        sql_q "SELECT value FROM message WHERE lang='" + lang + "' AND key='" + key + "'"
        if stat == 0 :return ""
    return sql_v("value")
#global
