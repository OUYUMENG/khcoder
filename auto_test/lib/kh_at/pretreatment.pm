package kh_at::pretreatment;
use base qw(kh_at);
use strict;

# �ƥ��Ƚ��Ͽ�: 7

sub _exec_test{
	my $self = shift;
	my $t = '';
	
	# �ָ����з�̤��ǧ��
	gui_window::morpho_check->open;
	my $win_src = $::main_gui->get('w_morpho_check');
	$win_src->entry->insert(0,gui_window->gui_jchar('´�Ⱦڽ�'));
	$win_src->search;
	$t .= "�������з�̤��ǧ:\n".Jcode->new(
		gui_window->gui_jg( gui_hlist->get_all( $win_src->list ),'reserve_rn'  )
	)->euc;
	
	# �ָ����з�̤��ǧ���ܺ١�
	$win_src->list->selectionSet(0);
	$win_src->detail;
	my $win_dtl = $::main_gui->get('w_morpho_detail');
	$t .= "�������з�̤��ǧ�ʾܺ١�:\n".Jcode->new(
		gui_window->gui_jg( gui_hlist->get_all( $win_dtl->list ),'reserve_rn'  ),
		'sjis'
	)->euc;

	# �ָ�μ������ס��ʻ������
	gui_window::dictionary->open;
	my $win_dic1 = $::main_gui->get('w_dictionary');
	$win_dic1->{checks}[4] = 0;
	$win_dic1->{checks}[5] = 0;
	$win_dic1->hlist->update;
	$win_dic1->save;
	$t .= "���ʻ�������ѹ���:\n";
	$t .= "words_all:\t".Jcode->new(
		gui_window->gui_jg( $::main_gui->inner->{ent_num1}->get,'reserve_rn'  )
	)->euc."\n";
	$t .= "project_kinds:\t".Jcode->new(
		gui_window->gui_jg( $::main_gui->inner->{ent_num2}->get,'reserve_rn'  )
	)->euc."\n";

	gui_window::dictionary->open;
	my $win_dic2 = $::main_gui->get('w_dictionary');
	$win_dic2->{checks}[4] = 1;
	$win_dic2->{checks}[5] = 1;
	$win_dic2->hlist->update;
	$win_dic2->save;
	$t .= "���ʻ�����ʺ��ѹ���:\n";
	$t .= "words_all:\t".Jcode->new(
		gui_window->gui_jg( $::main_gui->inner->{ent_num1}->get,'reserve_rn'  )
	)->euc."\n";
	$t .= "project_kinds:\t".Jcode->new(
		gui_window->gui_jg( $::main_gui->inner->{ent_num2}->get,'reserve_rn'  )
	)->euc."\n";

	# ��ʣ���θ��Сע���TermExtract��
	use mysql_hukugo_te;
	mysql_hukugo_te->run_from_morpho;
	my $win_hukugo_te = gui_window::use_te_g->open;
	$t .= "��ʣ���θ��С�TermExtract��\n";
	$t .= Jcode->new(
		gui_window->gui_jg( gui_hlist->get_all($win_hukugo_te->{list}),'reserve_rn','reserve_rn'   )
	)->euc;
	
	# ��ʣ���θ��Сע�����䥡�
	use mysql_hukugo;
	mysql_hukugo->run_from_morpho;
	my $win_hukugo_ch = gui_window::hukugo->open;
	$t .= "��ʣ���θ��С���䥡�\n";
	$t .= Jcode->new(
		gui_window->gui_jg( gui_hlist->get_all($win_hukugo_ch->{list}),'reserve_rn'  )
	)->euc;
	
	$self->{result} = $t;
	return $self;
}

sub test_name{
	return 'pre-processing...';
}

1;